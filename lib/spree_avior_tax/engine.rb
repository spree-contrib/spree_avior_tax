require_relative 'configuration'

module SpreeAviorTax
  class Engine < Rails::Engine
    require 'spree/core'

    isolate_namespace Spree
    engine_name 'spree_avior_tax'

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    initializer 'spree_avior_tax.environment', before: :load_config_initializers do |_app|
      SpreeAviorTax::Config = SpreeAviorTax::Configuration.new
    end

    config.after_initialize do |app|
      app.config.spree.calculators.tax_rates << SpreeAviorTax::Calculator::AviorTaxCalculator
    end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_decorator*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

    config.to_prepare(&method(:activate).to_proc)
  end
end
