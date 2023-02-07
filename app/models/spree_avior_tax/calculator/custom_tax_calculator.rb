

module SpreeAviorTax
  module Calculator
    class AviorTaxCalculator < Spree::Calculator
      def self.description
        Spree.t(:avior_tax)
      end

      def compute_order(_order)
        raise NotImplementedError
      end

      def compute_line_item(item)
        raise NotImplementedError
      end

      def compute_shipment(shipment)
        raise NotImplementedError
      end

      def compute_shipping_rate(_shipping_rate)
        raise NotImplementedError
      end
    end
  end
end
