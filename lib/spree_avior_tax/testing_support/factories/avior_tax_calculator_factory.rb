FactoryBot.define do
  factory :avior_tax_calculator, class: SpreeAviorTax::Calculator::AviorTaxCalculator do
    calculable { |calculator| calculator.association(:tax_rate) }

    factory :avior_tax_calculator_with_tax_rate_included_in_price do
      calculable { |calculator| calculator.association(:avior_tax_tax_rate_included_in_price) }
    end
  end
end
