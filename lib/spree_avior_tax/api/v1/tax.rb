module SpreeAviorTax
  module API
    module V1
      module Tax
        def calculate_tax(input_products = [])
          payload = input_products.map(&:to_h)
          url = "#{service_url}/suttaxd/gettax/"
          products = post_request(url, payload.to_json)
          products.map { |product| build_product(product) }
        end
      end
    end
  end
end
