module SpreeAviorTax
  module Calculator
    class LineItemShipmentTax < SpreeAviorTax::Base
      CACHE_EXPIRATION_DURATION = 10.minutes

      def call(item:)
        order = item.order
        tax_address = order.tax_address

        rails_cache_key = cache_key(order, item, tax_address)

        Rails.cache.fetch(rails_cache_key, expires_in: CACHE_EXPIRATION_DURATION) do
          payload = tax_params(order, tax_address)
          response = client.calculate_tax payload
          body = JSON.parse response.body, symbolize_names: true
          amount = body[:"fips tax amount 1"]
          success(amount)
        end
      end

      def tax_params(order, address)
        {
          'date' => Time.now.strftime('%Y%d%m'),
          'record number' => order.number,
          'seller id' => order.user_id,
          'seller location id' => address.id,
          'seller state' => address.state.name,
          'delivery method' => '',
          'customer entity code' => 'T',
          'ship to address' => '417 n main st',
          'ship to suite' => '',
          'ship to city' => address.city,
          'ship to county' => '',
          'ship to state' => address.state.abbr,
          'ship to zip code' => address.zipcode,
          'ship to zip plus' => '',
          'sku' => '',
          'amount of sale' => order.item_total
        }
      end

      def cache_key(order, item, address)
        [Spree::LineItem.to_s, order.id, item.id, address.state_id, address.zipcode, item.taxable_amount, :amount_to_collect]
      end
    end
  end
end
