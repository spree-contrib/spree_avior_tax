describe SpreeAviorTax::TaxRateDecorator do
  context 'when using AviorTaxCalculator' do
    let(:calculator) { build_stubbed :avior_tax_calculator }
    let(:tax_rate) { build_stubbed :tax_rate, calculator: calculator }

    describe '#label' do
      subject { tax_rate.send :label }

      it { is_expected.to eq Spree.t(:avior_tax) }
    end

    describe '#using_avior_tax?' do
      subject { tax_rate.send :using_avior_tax? }

      it { is_expected.to be true }
    end
  end

  context 'when not using AviorTaxCalculator' do
    let(:calculator) { build_stubbed :default_tax_calculator }
    let(:tax_rate) { build_stubbed :tax_rate, calculator: calculator, show_rate_in_label: false }

    describe '#label' do
      subject { tax_rate.send :label }

      it { is_expected.to eq tax_rate.name }
    end

    describe '#using_avior_tax?' do
      subject { tax_rate.send :using_avior_tax? }

      it { is_expected.to be false }
    end
  end
end
