module SpreeAviorTax
  module TaxRateDecorator
    private

    def label
      return super unless using_avior_tax?

      Spree.t :avior_tax
    end

    def using_avior_tax?
      calculator_type == SpreeAviorTax::Calculator::AviorTaxCalculator.to_s
    end
  end
end

Spree::TaxRate.prepend SpreeAviorTax::TaxRateDecorator
