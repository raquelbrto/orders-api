Rails.application.routes.draw do
  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"
  namespace :api do
    namespace :v1 do
      resources :transactions do
        collection do
          post "process-file", to: "transactions#process_file"
        end
      end
      resources :products, only: [ :index, :show ]
      resources :orders, only: [ :index, :show, :destroy ] do
        collection do
          get "search"
        end
      end
      resources :users, only: [ :index, :show ]
    end
  end

  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
end
