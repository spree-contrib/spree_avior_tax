module Spree
  module Admin
    class AviorTaxSettingsController < Spree::Admin::BaseController
      def edit
        @basic_preferences_api = %i[service_url username password]
        @preferences_api = %i[enabled company_name token seller_id seller_location_id seller_state customer_entity_code]
        @us = Spree::Country.find_by(iso: 'US')
      end

      def update
        params.each do |name, value|
          SpreeAviorTax::Config[name] = value if SpreeAviorTax::Config.has_preference? name
        end

        flash[:success] = Spree.t(:avior_tax_settings_updated)
        redirect_to edit_admin_avior_tax_settings_path
      end
    end
  end
end
