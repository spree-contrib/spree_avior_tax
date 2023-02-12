module SpreeAviorTax
  module API
    module Errors
      class AviorTaxServerError < StandardError
        attr_reader :response

        def initialize(response = nil)
          super
          @response = response
        end
      end
    end
  end
end
