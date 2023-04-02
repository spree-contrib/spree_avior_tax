require 'json'

module SpreeAviorTax
  module API
    module V1
      module Tax
        def calculate_tax(input_products = [])
          payload = input_products.map(&:to_h)
          url = "#{service_url}/suttaxd/gettax/"
          products = post_request(url, payload.to_json)
          products.map do |product|
            SpreeAviorTax::API::Output::Product.new(
              date: product['date'],
              record_number: product['record number'],
              seller_id: product['seller id'],
              seller_location_id: product['seller location id'],
              seller_state: product['seller state'],
              delivery_method: product['delivery method'],
              customer_entity_code: product['customer entity code'],
              ship_to_address: product['ship to address'],
              ship_to_suite: product['ship to suite'],
              ship_to_city: product['ship to city'],
              ship_to_county: product['ship to county'],
              ship_to_state: product['ship to state'],
              ship_to_zip_code: product['ship to zip code'],
              ship_to_zip_plus: product['ship to zip plus'],
              sku: product['sku'],
              amount_of_sale: product['amount of sale'],
              resulttype: product['resulttype'],
              taxability_code: product['taxability code'],
              fips_jurisdiction_code_1: product['fips jurisdiction code 1'],
              fips_tax_rate_1: product['fips tax rate 1'],
              fips_tax_amount_1: product['fips tax amount 1'],
              fips_jurisdiction_code_2: product['fips jurisdiction code 2'],
              fips_tax_rate_2: product['fips tax rate 2'],
              fips_tax_amount_2: product['fips tax amount 2']
            )
          end
        end
      end
    end
  end
end
