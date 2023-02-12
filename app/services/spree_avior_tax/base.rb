module SpreeAviorTax
  class Base
    prepend Spree::ServiceModule::Base

    private

    def client
      SpreeAviorTax::Client.new client_params
    end

    def client_params
      {
        service_url: SpreeAviorTax::Config[:service_url],
        user_id: SpreeAviorTax::Config[:user_id],
        password: SpreeAviorTax::Config[:password]
      }
    end
  end
end
