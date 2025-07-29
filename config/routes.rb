Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")

  root "photos#index" # show all posts of photos in guest mode


    devise_scope :user do
        get "/login", to: "devise/sessions#new" # login_*
        get "/signup", to: "devise/registrations#new"  # signup_* helper by default
    end
    devise_for :users,  controllers: {
        omniauth_callbacks: "users/omniauth_callbacks",
        registrations: "registrations"
    }


    resources :users, except: [ :edit ] do
        get "/:tab/photos", to: "photos#index_feeds", as: :tab_photos
        get "/:tab/albums", to: "albums#index_feeds", as: :tab_albums

        resources :photos, shallow: true, except: [ :index ] do
            collection do
                get "", to: "photos#index_user", as: :index # index_user_photos
            end
        end

        resources :albums, shallow: true
    end


    resources :profiles do
        # profiles/:profile_id/photos
        get "/photos", to: "photos#index_profile", as: :photos # profile_photos
    end

  namespace :admin do
    resources :users, only: [ :index, :edit, :update ], controller: "manage_users"
    resources :albums, only: [ :index, :edit, :update ], controller: "manage_albums"
    resources :photos, only: [ :index, :edit, :update ], controller: "manage_photos"
  end
end
