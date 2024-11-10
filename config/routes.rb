# config/routes.rb
Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      resources :files, only: [:index, :create, :show]
      resources :auth, only: [] do
        collection do
          post 'signin', to: 'auth#signin'
          post 'signup', to: 'auth#signup'
        end
      end
    end
  end
end
