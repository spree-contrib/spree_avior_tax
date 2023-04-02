module SpreeAviorTax
  class Configuration < ::Spree::Preferences::Configuration
    preference :enabled, :boolean, default: true
    preference :company_name, :string
    preference :username, :string
    preference :password, :password
    preference :service_url, :string
    preference :token, :string
  end
end
