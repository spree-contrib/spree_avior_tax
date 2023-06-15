describe SpreeAviorTax::AviorTax do
  before do
    Spree::Config[:tax_using_ship_address] = false
    SpreeAviorTax::Config[:service_url] = 'https://developer.avior.tax'
    SpreeAviorTax::Config[:token] = '123456789'
    SpreeAviorTax::Config[:seller_id] = 'Z123456789'
    SpreeAviorTax::Config[:seller_location_id] = '1'
    SpreeAviorTax::Config[:seller_state] = 'FL'
    SpreeAviorTax::Config[:customer_entity_code] = 'T'

    stub_request(:post, 'https://developer.avior.tax/api/auth/token/login/')
      .with(
        body: '{"username":"test","password":"test"}',
        headers: {
          'Content-Type' => 'application/json'
        }
      )
      .to_return(status: 200, body: '{"auth_token": "123456789"}', headers: {
                   'Content-Type' => 'application/json'
                 })

    stub_request(:post, 'https://developer.avior.tax/suttaxd/gettax/')
      .with(
        headers: {
          'Authorization' => 'Token 123456789',
          'Content-Type' => 'application/json'
        }
      )
      .to_return(status: 200, body: fixture('client/valid_product_response.json'), headers: {
                   'Content-Type' => 'application/json'
                 })
  end

  let(:order) { create(:avior_tax_order_with_line_items, number: 'R523355') }
  let(:line_item) { order.line_items.first }
  let(:shipment) { create(:shipment, order: order) }
  let(:tax_address) { order.tax_address }
  let(:avior_tax) { described_class.new(order: order, line_item: line_item, shipment: shipment) }

  describe '#login' do
    it 'returns the correct token' do
      expect(avior_tax.login('test', 'test')).to eq({ 'auth_token' => '123456789' })
    end
  end

  describe 'calculations' do
    let(:output) do
      body = SpreeAviorTax::API::Output::Product.new(
        date: '20200701',
        record_number: '523355',
        seller_id: 'Z123456789',
        seller_location_id: '1',
        seller_state: 'FL',
        delivery_method: 'N',
        customer_entity_code: 'T',
        ship_to_address: '417 Meridian Ave',
        ship_to_suite: '',
        ship_to_city: 'Bal Harbour',
        ship_to_county: 'Miami-Dade',
        ship_to_state: 'FL',
        ship_to_zip_code: '33154',
        ship_to_zip_plus: '',
        sku: '223443',
        amount_of_sale: '10',
        resulttype: '0',
        taxability_code: ''
      )
      taxes = [SpreeAviorTax::API::Output::Tax.new(
        fips_jurisdiction_code: '12',
        fips_tax_rate: '0.06',
        fips_tax_amount: '0.60'
      ), SpreeAviorTax::API::Output::Tax.new(
        fips_jurisdiction_code: '086',
        fips_tax_rate: '0.01',
        fips_tax_amount: '0.10'
      )]
      body.taxes = taxes
      [body]
    end

    describe '#calculate_for_order' do
      it 'returns the correct tax amount for order' do
        response = avior_tax.calculate_for_order(order, line_item)
        expect(response).to eq output
      end
    end

    describe '#calculate_for_shipment' do
      it 'returns the correct tax amount for shipment' do
        response = avior_tax.calculate_for_shipment(order, shipment)
        expect(response).to eq output
      end
    end
  end

  describe 'parameters' do
    let(:line_item_params) do
      SpreeAviorTax::API::Input::Product.new(
        date: order.updated_at.strftime('%Y%m%d'),
        record_number: record_number(order),
        seller_id: SpreeAviorTax::Config[:seller_id],
        seller_location_id: SpreeAviorTax::Config[:seller_location_id],
        seller_state: SpreeAviorTax::Config[:seller_state],
        customer_entity_code: SpreeAviorTax::Config[:customer_entity_code],
        delivery_method: 'N',
        ship_to_address: order.tax_address.address1,
        ship_to_suite: order.tax_address.address2,
        ship_to_city: order.tax_address.city,
        ship_to_county: order.tax_address.county,
        ship_to_state: order.tax_address.state.abbr,
        ship_to_zip_code: order.tax_address.zipcode,
        ship_to_zip_plus: '',
        sku: line_item.variant.sku,
        amount_of_sale: line_item.discounted_amount
      )
    end
    let(:shipment_params) do
      SpreeAviorTax::API::Input::Product.new(
        date: order.updated_at.strftime('%Y%m%d'),
        record_number: record_number(order),
        seller_id: SpreeAviorTax::Config[:seller_id],
        seller_location_id: SpreeAviorTax::Config[:seller_location_id],
        seller_state: SpreeAviorTax::Config[:seller_state],
        customer_entity_code: SpreeAviorTax::Config[:customer_entity_code],
        delivery_method: 'N',
        ship_to_address: order.tax_address.address1,
        ship_to_suite: order.tax_address.address2,
        ship_to_city: order.tax_address.city,
        ship_to_county: order.tax_address.county,
        ship_to_state: order.tax_address.state.abbr,
        ship_to_zip_code: order.tax_address.zipcode,
        ship_to_zip_plus: '',
        sku: '',
        amount_of_sale: shipment.discounted_cost
      )

      describe '#record_number' do
        it 'returns the correct record number' do
          expect(avior_tax.send(:record_number, order)).to eq '523355'
        end
      end

      describe '#client_params' do
        it 'returns the correct client params' do
          expect(avior_tax.send(:client_params)).to eq(
            service_url: 'https://developer.avior.tax',
            token: '123456789'
          )
        end
      end

      describe '#line_item_params' do
        it 'returns the correct line item params' do
          expect(avior_tax.send(:line_item_params)).to eq line_item_params
        end
      end

      describe '#shipment_params' do
        it 'returns the correct shipment params' do
          expect(avior_tax.send(:shipment_params)).to eq shipment_params
        end
      end
    end
  end
end
