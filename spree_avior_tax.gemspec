lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift lib unless $LOAD_PATH.include?(lib)

require 'spree_avior_tax/version'

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_avior_tax'
  s.version     = SpreeAviorTax.version
  s.summary     = 'Add extension summary here'
  s.description = 'Add (optional) extension description here'
  s.required_ruby_version = '>= 2.5'

  s.author    = 'Collins Lagat'
  s.email     = 'cklagat@gmail.com'
  s.homepage  = 'https://github.com/collins-lagat/spree_avior_tax'
  s.license = 'BSD-3-Clause'

  s.files = `git ls-files`.split("\n").reject { |f| f.match(/^spec/) && !f.match(%r{^spec/fixtures}) }
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'deface'
  s.add_dependency 'httparty'
  s.add_dependency 'model_attribute', '~> 3.2'
  s.add_dependency 'spree_core', '>= 4.4.0'
  s.add_dependency 'spree_extension'

  s.add_development_dependency 'pg'
  s.add_development_dependency 'spree_dev_tools'
end
