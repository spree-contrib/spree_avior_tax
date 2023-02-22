source 'https://rubygems.org'

spree_version = '>= 4.4.0'
gem 'deface'
gem 'httparty'
# gem 'spree', spree_version
gem 'spree', github: 'spree/spree', branch: 'main'
gem 'spree_backend', github: 'spree/spree_backend', branch: 'main'
# gem 'spree_backend', spree_version

group :test do
  gem 'rails-controller-testing'
end

group :development do
  gem 'htmlbeautifier'
  gem 'rcodetools', require: false
  gem 'reek', require: false
  gem 'rubocop', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  gem 'solargraph', require: false
end

gemspec
