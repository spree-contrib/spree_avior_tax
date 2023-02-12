require 'spree_avior_tax/api/utils'
require 'spree_avior_tax/api/errors'
require 'spree_avior_tax/api/v1/tax'

module SpreeAviorTax
  class Client
    include SpreeAviorTax::API::Utils
    include SpreeAviorTax::API::V1::Tax

    attr_accessor :service_url, :user_id, :password

    def initialize(opts = {})
      opts.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
    end

    def headers
      credentials = Digest::MD5.hexdigest("#{user_id} #{password}")
      {
        'Content-Type' => 'application/json',
        'Authorization' => "Basic #{credentials}"
      }
    end
  end
end
