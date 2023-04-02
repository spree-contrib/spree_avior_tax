module Spree
  module Admin
    class AviorTaxSettingsController < Spree::Admin::BaseController
      def edit
        @preferences_api = %i[enabled service_url company_name username password token]
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
