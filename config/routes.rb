Rails.application.routes.draw do
  get "products/show"
  get "categories/show"
  root "home#index" # Set the home page
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :categories, only: [ :show ] # Route to show products by category
  resources :products, only: [ :show ] # Route for product details
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

   # Defines the root path route ("/")
   # root "posts#index"

   # adds routes for the cart and its methods
   post "cart/add", to: "cart#add", as: "add_cart"
  # Define cart show route without requiring an id
  get "cart", to: "cart#show", as: "cart"
  delete "cart/remove", to: "cart#remove", as: "remove_cart"
  patch "cart/update", to: "cart#update", as: "update_cart"
  get "cart/update_taxes", to: "cart#update_taxes"
  post "cart/create_order", to: "cart#create_order", as: "create_order"

  # Cart actions for adding, updating, and removing items
  resources :cart, only: [ :show ] do
    collection do
      post :add
      patch :update
      delete :remove
      post :create_order
      get :update_taxes
    end
  end
end
