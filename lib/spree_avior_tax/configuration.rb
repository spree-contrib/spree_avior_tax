module SpreeAviorTax
  class Configuration < ::Spree::Preferences::Configuration
    preference :enabled, :boolean, default: true
    preference :company_name, :string
    preference :username, :string
    preference :password, :password
    preference :service_url, :string
    preference :token, :string
    preference :seller_id, :string
    preference :seller_location_id, :string
    preference :seller_state, :string
    preference :customer_entity_code, :string
  end
end
