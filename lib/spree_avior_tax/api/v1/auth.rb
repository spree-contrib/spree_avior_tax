module SpreeAviorTax
  module API
    module V1
      module Auth
        def login(username, password)
          url = "#{service_url}/api/auth/token/login/"
          headers = {
            'Content-Type' => 'application/json'
          }
          post_request(url, { username: username, password: password }.to_json, headers)
        end
      end
    end
  end
end
