module SpreeAviorTax
  module API
    module Utils
      def post_request(endpoint, data)
        response = HTTParty.post(endpoint,
                                 {
                                   body: data,
                                   headers: headers
                                 })

        unless response.code == 200 || response.code == 201
          raise SpreeAviorTax::API::Errors::AviorTaxServerError.new(response),
                "HTTP Code #{response.code}: #{response.body}"
        end

        response
      end
    end
  end
end
