require 'spec_helper'

describe SpreeAviorTax::Client do
  describe 'client intitialization' do
    client = described_class.new(service_url: 'https://developer.avior.tax', token: '123456789')
    it 'sets up the service_url correctly' do
      expect(client.service_url).to eq 'https://developer.avior.tax'
    end

    it 'sets up the token correctly' do
      expect(client.token).to eq '123456789'
    end
  end

  describe 'client headers' do
    it 'sets up the headers correctly' do
      client = described_class.new(service_url: 'https://developer.avior.tax', token: '123456789')
      expect(client.headers).to eq({
                                     'Content-Type' => 'application/json',
                                     'Authorization' => 'Token 123456789'
                                   })
    end
  end

  describe 'client post_request' do
    let(:client) { described_class.new(service_url: 'https://developer.avior.tax', token: '123456789') }

    it 'returns the response body' do
      stub_request(:post, 'https://developer.avior.tax/')
        .with(
          body: 'test=1',
          headers: {
            'Authorization' => 'Token 123456789',
            'Content-Type' => 'application/json'
          }
        )
        .to_return(status: 200, body: '{"test":1}', headers: {
                     'Content-Type' => 'application/json'
                   })
      response_body = client.post_request('https://developer.avior.tax', { 'test' => 1 })
      expect(response_body).to eq({ 'test' => 1 })
    end

    it 'throws error' do
      stub_request(:post, 'https://developer.avior.tax/')
        .with(
          body: 'test=1',
          headers: {
            'Authorization' => 'Token 123456789',
            'Content-Type' => 'application/json'
          }
        )
        .to_return(status: 200, body: '[{"error code": "999","error comments":"test error"}]', headers: {
                     'Content-Type' => 'application/json'
                   })
      expect {
        client.post_request('https://developer.avior.tax', { 'test' => 1 })
      }.to raise_error(SpreeAviorTax::API::Errors::AviorTaxServerError,
                       'AviorTax server returned an error (error code 999): test error')
    end
  end

  describe 'client calculate_tax' do
    let(:client) { described_class.new(service_url: 'https://developer.avior.tax', token: '123456789') }

    let(:body) do
      items = JSON.parse(fixture('client/valid_product_body.json').read)
      items.map { |item| SpreeAviorTax::API::Input::Product.new(item) }
    end

    let(:response) do
      items = JSON.parse(fixture('client/valid_product_response.json').read)
      items.map do |item|
        product = SpreeAviorTax::API::Output::Product.new({
                                                            date: item['date'],
                                                            record_number: item['record number'],
                                                            delivery_method: item['delivery method'],
                                                            customer_entity_code: item['customer entity code'],
                                                            sku: item['sku'],
                                                            amount_of_sale: item['amount of sale'],
                                                            seller_id: item['seller id'],
                                                            seller_location_id: item['seller location id'],
                                                            seller_state: item['seller state'],
                                                            ship_to_address: item['ship to address'],
                                                            ship_to_suite: item['ship to suite'],
                                                            ship_to_city: item['ship to city'],
                                                            ship_to_county: item['ship to county'],
                                                            ship_to_state: item['ship to state'],
                                                            ship_to_zip_code: item['ship to zip code'],
                                                            ship_to_zip_plus: item['ship to zip plus'],
                                                            taxability_code: item['taxability code'],
                                                            resulttype: item['resulttype']
                                                          })
        count = 1
        taxes = []
        while item["fips jurisdiction code #{count}"]
          taxes << SpreeAviorTax::API::Output::Tax.new({
                                                         fips_jurisdiction_code: item["fips jurisdiction code #{count}"],
                                                         fips_tax_rate: item["fips tax rate #{count}"],
                                                         fips_tax_amount: item["fips tax amount #{count}"]
                                                       })
          count += 1
        end
        product.taxes = taxes
        product
      end
    end

    it 'returns the response body' do
      stub_request(:post, 'https://developer.avior.tax/suttaxd/gettax/')
        .with(
          body: body.map(&:to_h).to_json,
          headers: {
            'Authorization' => 'Token 123456789',
            'Content-Type' => 'application/json'
          }
        )
        .to_return(status: 200, body: fixture('client/valid_product_response.json'), headers: {
                     'Content-Type' => 'application/json'
                   })
      response_body = client.calculate_tax(body)
      expect(response_body).to eq response
    end
  end
end
