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
end
