describe SpreeAviorTax::OrderDecorator do
  let(:order) { create(:avior_tax_order) }

  describe '#avior_tax_total' do
    it 'returns the correct avior tax total' do
      expect(order.avior_tax_total).to eq 0.7
    end
  end

  describe '#avior_tax_included' do
    it 'returns false' do
      expect(order.avior_tax_included).to eq false
    end
  end
end
