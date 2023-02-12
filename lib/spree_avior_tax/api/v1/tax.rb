require 'json'

module SpreeAviorTax
  module API
    module V1
      module Tax
        def calculate_tax(payload = {})
          post_request(service_url, payload.to_json)
        end
      end
    end
  end
end
