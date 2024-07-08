Rails.application.routes.draw do
  devise_for :users, :controllers => {:registrations => "registrations"}
  get 'profile/reviews', to: 'profile#reviews', as: 'user_reviews'
  get 'profile/likes', to: 'profile#likes', as: 'user_likes'
  get 'profile/:id', to: 'profile#show', as: 'profile'
  match "/404", to: "errors#not_found", via: :all
  match "/500", to: "errors#internal_server_error", via: :all
  resources :recommendations do
    resource :like, only: [:create, :destroy]
    resources :reviews, only: [:create]
  end
  resources :reviews, only: [:edit, :update, :destroy]
  root to: "recommendations#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
