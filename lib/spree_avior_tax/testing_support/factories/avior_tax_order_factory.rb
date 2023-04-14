FactoryBot.define do
  factory :avior_tax_order, class: Spree::Order do
    user
    bill_address { create(:avior_tax_address) }
    completed_at { nil }
    email        { user&.email }
    currency     { 'USD' }

    transient do
      line_items_price { BigDecimal(10) }
      attach_to_default_store { true }
    end

    before(:create) do |order|
      if order.store.blank?
        default_store = Spree::Store.default.persisted? ? Spree::Store.default : nil
        store = default_store || create(:store)

        order.store = store
      end
    end

    factory :avior_tax_order_with_line_items do
      bill_address { create(:avior_tax_address) }
      ship_address { create(:avior_tax_address) }

      transient do
        line_items_count       { 1 }
        without_line_items     { false }
        shipment_cost          { 100 }
        shipping_method_filter { Spree::ShippingMethod::DISPLAY_ON_FRONT_END }
      end

      after(:create) do |order, evaluator|
        unless evaluator.without_line_items
          create_list(:avior_tax_line_item, evaluator.line_items_count, order: order, price: evaluator.line_items_price)
          order.line_items.reload
        end

        stock_location = order.line_items&.first&.variant&.stock_items&.first&.stock_location || create(:stock_location)
        create(:avior_tax_shipment, order: order, cost: evaluator.shipment_cost, stock_location: stock_location)
        order.shipments.reload

        order.update_with_updater!
      end
    end
  end
end
