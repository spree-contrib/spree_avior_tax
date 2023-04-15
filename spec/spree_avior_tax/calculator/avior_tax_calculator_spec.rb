require 'spec_helper'

describe SpreeAviorTax::Calculator::AviorTaxCalculator do
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

  let(:order) { create(:avior_tax_order) }
  let(:line_item) { create(:avior_tax_line_item, order: order, price: 10, quantity: 1) }
  let(:shipment) { create(:avior_tax_shipment, cost: 10, state: 'pending', stock_location: create(:stock_location)) }

  context 'with tax included in price' do
    let(:calculator) { create(:avior_tax_calculator_with_tax_rate_included_in_price) }

    describe '#compute_order' do
      it 'throws NotImplementedError error' do
        expect { calculator.compute_order(order) }.to raise_error(NotImplementedError)
      end
    end

    describe '#compute_line_item' do
      it 'returns 0' do
        expect(calculator.compute(line_item)).to eq 0
      end
    end

    describe '#compute_shipment' do
      it 'returns 0' do
        expect(calculator.compute_shipment(shipment)).to eq 0
      end
    end
  end

  context 'without tax included in price' do
    let(:calculator) { create(:avior_tax_calculator) }

    describe '#compute_order' do
      it 'throws NotImplementedError error' do
        expect { calculator.compute_order(order) }.to raise_error(NotImplementedError)
      end
    end

    describe '#compute_line_item' do
      it 'returns the correct tax amount for line_item' do
        expect(calculator.compute(line_item)).to eq 0.7
      end
    end

    describe '#compute_shipment' do
      it 'returns the correct tax amount for shipment' do
        expect(calculator.compute_shipment(shipment)).to eq 0.7
      end
    end
  end
end
