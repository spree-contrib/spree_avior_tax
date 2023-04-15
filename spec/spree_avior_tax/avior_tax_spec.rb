describe SpreeAviorTax::AviorTax do
  before do
    Spree::Config[:tax_using_ship_address] = false
    SpreeAviorTax::Config[:service_url] = 'https://developer.avior.tax'
    SpreeAviorTax::Config[:token] = '123456789'

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

  let(:order) { create(:avior_tax_order_with_line_items) }
  let(:line_item) { order.line_items.first }
  let(:shipment) { create(:shipment, order: order) }
  let(:tax_address) { order.tax_address }
  let(:avior_tax) { described_class.new }

  describe '#calculate_for_order' do
    it 'returns the correct tax amount for order' do
      response = avior_tax.calculate_for_order(order, line_item)
      expect(response).to eq 0.7
    end
  end

  describe '#calculate_for_shipment' do
    it 'returns the correct tax amount for shipment' do
      response = avior_tax.calculate_for_shipment(order, shipment)
      expect(response).to eq 0.7
    end
  end
end
