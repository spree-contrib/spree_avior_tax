module Spree
  module Admin
    class AviorTaxSettingsController < Spree::Admin::BaseController
      def edit
        @preferences_api = %i[avior_tax_api_key]
      end

      def update
        Spree::Config[:avior_tax_api_key] = params[:avior_tax_api_key]

        flash[:success] = Spree.t(:avior_tax_settings_updated)
        redirect_to edit_admin_avior_tax_settings_path
      end
    end
  end
end
