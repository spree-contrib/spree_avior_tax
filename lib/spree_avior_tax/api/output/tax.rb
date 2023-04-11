module SpreeAviorTax
  module API
    module Output
      class Tax
        extend ModelAttribute

        attribute :fips_jurisdiction_code, :string
        attribute :fips_tax_rate, :string
        attribute :fips_tax_amount, :string

        def initialize(attributes = {})
          set_attributes(attributes)
        end
      end
    end
  end
end
