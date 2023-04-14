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

      def login
        validated_params = params.permit(:service_url, :username, :password)

        raise ActionController::ParameterMissing, :service_url unless validated_params.key?(:service_url)
        raise ActionController::ParameterMissing, :username unless validated_params.key?(:username)
        raise ActionController::ParameterMissing, :password unless validated_params.key?(:password)

        SpreeAviorTax::Config[:service_url] = validated_params[:service_url]

        client = SpreeAviorTax::Client.new(
          service_url: SpreeAviorTax::Config[:service_url]
        )

        data = client.login(validated_params[:username], validated_params[:password])

        if data['auth_token'].nil?
          flash[:error] = Spree.t(:avior_tax_login_failed)
          redirect_to edit_admin_avior_tax_settings_path
          return
        end
        SpreeAviorTax::Config[:username] = validated_params[:username]
        SpreeAviorTax::Config[:password] = validated_params[:password]
        SpreeAviorTax::Config[:token] = data['auth_token']

        redirect_to edit_admin_avior_tax_settings_path
      rescue SpreeAviorTax::API::Errors::AviorTaxServerError => e
        flash[:error] = e.response['non_field_errors'].join(', ')
        redirect_to edit_admin_avior_tax_settings_path
      end
    end
  end
end
