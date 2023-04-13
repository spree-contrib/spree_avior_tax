module SpreeAviorTax
  module API
    module Utils
      module HTTP
        def post_request(endpoint, data, headers = {})
          response = HTTParty.post(endpoint,
                                   {
                                     body: data,
                                     headers: headers
                                   })

          unless response.code == 200 || response.code == 201
            raise SpreeAviorTax::API::Errors::AviorTaxServerError.new(response),
                  "HTTP Code #{response.code}: #{response.body}"
          end

          response_body = JSON.parse(response.body)

          fail_or_return_response_body(response_body)
        end

        private

        def fail_or_return_response_body(body)
          if body.nil?
            raise SpreeAviorTax::API::Errors::AviorTaxServerError.new(body),
                  'AviorTax server returned an empty response'
          end

          if body.is_a?(Hash) && body['error code']
            raise SpreeAviorTax::API::Errors::AviorTaxServerError.new(body),
                  "AviorTax server returned an error (error code #{body['error code']}): #{body['error comments']}"
          end

          return body unless body.is_a?(Array)

          body.each do |item|
            fail_or_return_response_body(item)
          end
        end
      end
    end
  end
end
