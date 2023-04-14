FactoryBot.define do
  factory :avior_tax_tax_rate, class: Spree::TaxRate do
    name { "TaxRate - #{rand(999_999)}" }
    zone
    tax_category
    amount { 0.1 }

    association(:calculator, factory: :default_tax_calculator)

    factory :avior_tax_tax_rate_included_in_price do
      included_in_price { true }
    end
  end
end
