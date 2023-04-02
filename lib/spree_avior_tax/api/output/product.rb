module SpreeAviorTax
  module API
    module Output
      class Product
        extend ModelAttribute

        attribute :date, :string
        attribute :record_number, :string
        attribute :seller_id, :string
        attribute :seller_location_id, :string
        attribute :seller_state, :string
        attribute :delivery_method, :string
        attribute :customer_entity_code, :string
        attribute :ship_to_address, :string
        attribute :ship_to_suite, :string
        attribute :ship_to_city, :string
        attribute :ship_to_county, :string
        attribute :ship_to_state, :string
        attribute :ship_to_zip_code, :string
        attribute :ship_to_zip_plus, :string
        attribute :sku, :string
        attribute :amount_of_sale, :string
        attribute :resulttype, :string
        attribute :taxability_code, :string
        attribute :fips_jurisdiction_code_1, :string
        attribute :fips_tax_rate_1, :string
        attribute :fips_tax_amount_1, :string
        attribute :fips_jurisdiction_code_2, :string
        attribute :fips_tax_rate_2, :string
        attribute :fips_tax_amount_2, :string

        def initialize(attributes = {})
          set_attributes(attributes)
        end

        def to_h
          {
            date: date,
            'record number' => record_number,
            'seller id' => seller_id,
            'seller location id' => seller_location_id,
            'seller state' => seller_state,
            'delivery method' => delivery_method,
            'customer entity code' => customer_entity_code,
            'ship to address' => ship_to_address,
            'ship to suite' => ship_to_suite,
            'ship to city' => ship_to_city,
            'ship to county' => ship_to_county,
            'ship to state' => ship_to_state,
            'ship to zip code' => ship_to_zip_code,
            'ship to zip plus' => ship_to_zip_plus,
            sku: sku,
            'amount of sale' => amount_of_sale,
            'resulttype' => resulttype,
            'taxability code' => taxability_code,
            'fips jurisdiction code 1' => fips_jurisdiction_code_1,
            'fips tax rate 1' => fips_tax_rate_1,
            'fips tax amount 1' => fips_tax_amount_1,
            'fips jurisdiction code 2' => fips_jurisdiction_code_2,
            'fips tax rate 2' => fips_tax_rate_2,
            'fips tax amount 2' => fips_tax_amount_2
          }
        end
      end
    end
  end
end
