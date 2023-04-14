FactoryBot.define do
  factory :avior_tax_line_item, class: Spree::LineItem do
    order { create(:avior_tax_order) }
    quantity { 1 }
    price    { BigDecimal('10.00') }
    currency { order.currency }
    product do
      if order&.store&.present?
        create(:product, stores: [order.store])
      else
        create(:product)
      end
    end
    variant { product.master }
  end
end
