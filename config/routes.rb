Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

# Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
# get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
# get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

# Defines the root path route ("/")
# root "posts#index"

devise_scope :user do
  get "/login", to: "devise/sessions#new" # login_*
  get "/signup", to: "devise/registrations#new"  # signup_* helper by default
end
devise_for :users



  root "users#index"

  resources :users, :albums, :photos, :profiles

  resources :users do
    resources :photos, :albums, shallow: true
  end

  namespace :admin do
    resources :users, only: [ :index, :edit, :update ], controller: "manage_users"
    resources :albums, only: [ :index, :edit, :update ], controller: "manage_albums"
    resources :photos, only: [ :index, :edit, :update ], controller: "manage_photos"
  end

  get "/logout", to: "authentication#logout", as: :logout
  get "/forgot_pw", to: "authentication#forgot_pw", as: :forgot_pw
end
