module SpreeAviorTax
  module Calculator
    class LineItemTax < SpreeAviorTax::Base
      CACHE_EXPIRATION_DURATION = 10.minutes

      def call(item:)
        order = item.order
        tax_address = order.tax_address

        rails_cache_key = cache_key(order, item, tax_address)

        amount = Rails.cache.fetch(rails_cache_key, expires_in: CACHE_EXPIRATION_DURATION) do
          payload = tax_params(order, tax_address)
          response = client.calculate_tax payload
          body = JSON.parse response.body
          amount = body['fips tax amount 1']
          amount
        end
        # order.errors.add(:avior_tax, Spree.t(:avior_invalid_data_in_request)) if amount
        success(amount)
      end

      def tax_params(order, address)
        {
          'date' => Time.now.utc.strftime('%Y/%m/%d'),
          'record number' => order.number,
          'seller id' => order.user_id,
          'seller location id' => '',
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
        [Spree::LineItem.to_s, order.id, item.id, address.state_id, address.zipcode, item.taxable_amount, :amount_to_collect_two]
      end
    end
  end
end
