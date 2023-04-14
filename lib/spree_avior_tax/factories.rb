FactoryBot.define do
  # Define your Spree extensions Factories within this file to enable applications, and other extensions to use and override them.
  #
  # Example adding this to your spec_helper will load these Factories for use:
  require 'spree_avior_tax/testing_support/factories/avior_tax_address_factory'
  require 'spree_avior_tax/testing_support/factories/avior_tax_order_factory'
  require 'spree_avior_tax/testing_support/factories/avior_tax_line_item_factory'
  require 'spree_avior_tax/testing_support/factories/avior_tax_shipment_factory'
  require 'spree_avior_tax/testing_support/factories/avior_tax_calculator_factory'
  require 'spree_avior_tax/testing_support/factories/avior_tax_tax_rate_factory'
end
