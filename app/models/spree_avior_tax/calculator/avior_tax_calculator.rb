module SpreeAviorTax
  module Calculator
    class AviorTaxCalculator < Spree::Calculator
      include Spree::VatPriceCalculation

      def self.description
        Spree.t(:avior_tax)
      end

      def compute_order(_order)
        raise NotImplementedError
      end

      def compute_line_item(item)
        return 0 unless SpreeAviorTax::Config[:enabled]
        return 0 if rate.included_in_price

        result = LineItemTax.call(item: item)
        round_to_two_places(result.value)
      end

      def compute_shipment(shipment)
        return 0 unless SpreeAviorTax::Config[:enabled]
        return 0 if rate.included_in_price

        result = ShipmentTax.call(shipment: shipment)
        round_to_two_places(result.value)
      end

      def compute_shipping_rate(_shipping_rate)
        0
      end

      private

      def rate
        calculable
      end
    end
  end
end
