Rails.application.routes.draw do
  # Homepage
  root "properties#index"
  
  # User registration and profile
  get "signup", to: "users#new", as: "signup"
  resources :users, except: [:index, :destroy]
  
  # Authentication
  get "login", to: "sessions#new", as: "login"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy", as: "logout"
  
  # Properties
  resources :properties do
    # Nested routes for bookings
    resources :bookings, only: [:new, :create]
  end
  
  # Bookings
  resources :bookings, except: [:new, :create] do
    # Nested routes for reviews
    resources :reviews, only: [:new, :create]
  end
  
  # Reviews
  resources :reviews, only: [:edit, :update, :destroy]
  
  # Search
  get "search", to: "properties#search", as: "search"
  
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
