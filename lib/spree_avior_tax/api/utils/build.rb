module SpreeAviorTax
  module API
    module Utils
      module Build
        def build_product(product_hash)
          details = [
            seller_details(product_hash),
            shipping_details(product_hash),
            order_details(product_hash),
            tax_details(product_hash),
            result_details(product_hash)
          ].reduce(&:merge)

          product = SpreeAviorTax::API::Output::Product.new(details)
          product.taxes = build_tax_from_product(product_hash)
          product
        end

        def build_tax_from_product(product_hash)
          count = 1
          taxes = []
          while product_hash["fips jurisdiction code #{count}"]
            taxes << build_tax(product_hash, count)
            count += 1
          end
          taxes
        end

        private

        def seller_details(product_hash)
          {
            seller_id: product_hash['seller id'],
            seller_location_id: product_hash['seller location id'],
            seller_state: product_hash['seller state']
          }
        end

        def shipping_details(product_hash)
          {
            ship_to_address: product_hash['ship to address'],
            ship_to_suite: product_hash['ship to suite'],
            ship_to_city: product_hash['ship to city'],
            ship_to_county: product_hash['ship to county'],
            ship_to_state: product_hash['ship to state'],
            ship_to_zip_code: product_hash['ship to zip code'],
            ship_to_zip_plus: product_hash['ship to zip plus']
          }
        end

        def order_details(product_hash)
          {
            date: product_hash['date'],
            record_number: product_hash['record number'],
            delivery_method: product_hash['delivery method'],
            customer_entity_code: product_hash['customer entity code'],
            sku: product_hash['sku'],
            amount_of_sale: product_hash['amount of sale']
          }
        end

        def tax_details(product_hash)
          {
            taxability_code: product_hash['taxability code']
          }
        end

        def result_details(product_hash)
          {
            resulttype: product_hash['resulttype']
          }
        end

        def build_tax(product_hash, count)
          SpreeAviorTax::API::Output::Tax.new(
            fips_jurisdiction_code: product_hash["fips jurisdiction code #{count}"],
            fips_tax_rate: product_hash["fips tax rate #{count}"],
            fips_tax_amount: product_hash["fips tax amount #{count}"]
          )
        end
      end
    end
  end
end
