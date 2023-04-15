describe SpreeAviorTax::AddressDecorator do
  context 'when county is blank' do
    let(:address) { build(:address, county: nil) }

    describe 'validations' do
      it 'address is invalid' do
        expect(address).not_to be_valid
        expect(address.errors[:county]).to eq ["can't be blank"]
      end
    end
  end

  context 'when county is present' do
    let(:address) { build(:address, county: 'County') }

    describe 'validations' do
      it 'address is valid' do
        expect(address).to be_valid
      end
    end
  end
end
