module SpreeAviorTax
  module Calculator
    class ShipmentTax < SpreeAviorTax::Base
      CACHE_EXPIRATION_DURATION = 10.minutes

      def call(shipment:)
        raise StandardError, 'CDCDCD'
        order = shipment.order
        tax_address = order.tax_address

        rails_cache_key = cache_key(order, shipment, tax_address)
        Rails.cache.fetch(rails_cache_key, expires_in: CACHE_EXPIRATION_DURATION) do
          success(10)
        end
      end

      def cache_key(order, shipment, address)
        [Spree::Shipment.to_s, order.id, shipment.id, address.state_id, address.zipcode, shipment.cost, shipment.adjustments.reject do |adjustment|
                                                                                                          adjustment.source_type == Spree::TaxRate.to_s
                                                                                                        end.map(&:amount).sum.to_f, :amount_to_collect]
      end
    end
  end
end
