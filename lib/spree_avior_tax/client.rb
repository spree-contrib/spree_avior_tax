require 'json'
require 'spree_avior_tax/api/utils/http'
require 'spree_avior_tax/api/utils/build'
require 'spree_avior_tax/api/errors'
require 'spree_avior_tax/api/input/product'
require 'spree_avior_tax/api/output/product'
require 'spree_avior_tax/api/output/tax'
require 'spree_avior_tax/api/v1/auth'
require 'spree_avior_tax/api/v1/tax'

module SpreeAviorTax
  class Client
    include SpreeAviorTax::API::Utils::HTTP
    include SpreeAviorTax::API::Utils::Build
    include SpreeAviorTax::API::V1::Tax
    include SpreeAviorTax::API::V1::Auth

    attr_accessor :service_url, :token

    def initialize(opts = {})
      opts.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
    end

    def auth_headers
      {
        'Content-Type' => 'application/json',
        'Authorization' => "Token #{token}"
      }
    end
  end
end
