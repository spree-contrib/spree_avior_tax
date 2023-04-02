module SpreeAviorTax
  module Calculator
    class AviorTaxCalculator < Spree::Calculator
      include Spree::VatPriceCalculation

      CACHE_EXPIRATION_DURATION = 10.minutes

      def self.description
        Spree.t(:avior_tax)
      end

      def compute_order(_order)
        raise NotImplementedError
      end

      def compute_line_item(item)
        return 0 unless SpreeAviorTax::Config[:enabled]
        return 0 if rate.included_in_price

        round_to_two_places(tax_for_line_item(item))
      end

      def compute_shipment(shipment)
        return 0 unless SpreeAviorTax::Config[:enabled]
        return 0 if rate.included_in_price

        round_to_two_places(tax_for_shipment(shipment))
      rescue SpreeAviorTax::API::Errors::AviorTaxServerError => e
        errors.add(:base, e.message)
        Rails.logger.error "AviorTax server error: #{e.message}"
      end

      def compute_shipping_rate(_shipping_rate)
        0
      end

      private

      def rate
        calculable
      end

      def tax_for_line_item(item)
        order = item.order
        tax_address = order.tax_address

        rails_cache_key = cache_key(order, item, tax_address)

        Rails.cache.fetch(rails_cache_key, expires_in: CACHE_EXPIRATION_DURATION) do
          response = AviorTax.new.calculate_for_order(order, item)
          body = response.first
          amount = BigDecimal(body.fips_tax_amount_1) + BigDecimal(body.fips_tax_amount_2)
          amount
        end
      end

      def tax_for_shipment(shipment)
        order = shipment.order
        tax_address = order.tax_address

        rails_cache_key = cache_key(order, shipment, tax_address)

        Rails.cache.fetch(rails_cache_key, expires_in: CACHE_EXPIRATION_DURATION) do
          response = AviorTax.new.calculate_for_shipment(order, shipment)
          body = response.first
          amount = BigDecimal(body.fips_tax_amount_1) + BigDecimal(body.fips_tax_amount_2)
          amount
        end
      end

      def cache_key(order, item, address)
        if item.is_a?(Spree::LineItem)
          [Spree::LineItem.to_s, order.id, item.id, address.state_id, address.zipcode, item.taxable_amount, :amount_to_collect]
        else
          [Spree::Shipment.to_s, order.id, item.id, address.state_id, address.zipcode, item.cost, item.adjustments.reject do |adjustment|
                                                                                                    adjustment.source_type == Spree::TaxRate.to_s
                                                                                                  end.map(&:amount).sum.to_f, :amount_to_collect]
        end
      end
    end
  end
end
