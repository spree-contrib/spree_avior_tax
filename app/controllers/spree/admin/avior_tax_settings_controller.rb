module Spree
  module Admin
    class AviorTaxSettingsController < Spree::Admin::BaseController
      def edit
        @preferences_api = %i[enabled service_url company_name username password token]
      end

      def update
        SpreeAviorTax::Config[:enabled] = params[:enabled]
        SpreeAviorTax::Config[:company_name] = params[:company_name]
        SpreeAviorTax::Config[:service_url] = params[:service_url]
        SpreeAviorTax::Config[:user_id] = params[:user_id]
        SpreeAviorTax::Config[:password] = params[:password]

        flash[:success] = Spree.t(:avior_tax_settings_updated)
        redirect_to edit_admin_avior_tax_settings_path
      end
    end
  end
end
