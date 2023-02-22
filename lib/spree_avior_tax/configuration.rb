module SpreeAviorTax
  class Configuration < ::Spree::Preferences::Configuration
    preference :enabled, :boolean, default: true
    preference :company_name, :string
    preference :user_id, :string
    preference :password, :string
    preference :service_url, :string
  end
end
