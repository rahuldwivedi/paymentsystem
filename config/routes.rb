Rails.application.routes.draw do
  namespace :api, as: nil, defaults: { format: 'json' } do
    namespace :v1, as: nil do
      namespace :users do
        post 'authenticate',  to: 'sessions#create', as: 'login'
      end
      resources :transactions , only: %i() do
        collection do
          post :authorize
        end
        member do
          post :refund
        end
      end
    end
  end

  resources :transactions
  resources :merchants

  root to: 'transactions#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
