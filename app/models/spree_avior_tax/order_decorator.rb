module SpreeAviorTax
  module OrderDecorator
    def self.prepended(base)
      base.state_machine.before_transition from: :address do |order|
        !order.errors.added?(:avior_tax, Spree.t(:avior_invalid_data_in_request))
      end
    end
  end
end

Spree::Order.prepend SpreeAviorTax::OrderDecorator
