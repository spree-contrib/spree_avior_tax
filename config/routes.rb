Spree::Core::Engine.routes.draw do
  namespace :admin do
    resource :avior_tax_settings
    post '/avior_tax_settings/login', to: 'avior_tax_settings#login', as: :avior_tax_login
  end
end
