module SpreeAviorTax
  module AddressDecorator
    def self.prepended(base)
      base::ADDRESS_FIELDS << 'county' unless base::ADDRESS_FIELDS.include?('county')
      base.validates :county, presence: true
    end
  end
end

Spree::Address.prepend SpreeAviorTax::AddressDecorator
