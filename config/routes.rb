Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token

  namespace :admin do
    mount MaintenanceTasks::Engine, at: "/maintenance_tasks"
  end

  namespace :office, defaults: { department: "office" } do
    root "dashboard#index"
    resources :clients
    get :settings, to: "settings#index"
    resources :discounts, only: %i[ show edit update ]
    resources :products
    resources :suppliers
    resources :users, only: %i[ index show new create edit update destroy ]
  end

  namespace :sales, defaults: { department: "sales" } do
    root "dashboard#index"
    resources :clients, only: %i[ index ]
    resources :products, only: %i[ index show ]
    resources :orders, controller: "sales_orders", as: "sales_orders" do
      collection do
        post :preview_totals
      end
      resources :sales_order_items, only: %i[] do
        member do
          post :work_on, to: "sales_orders/works#create"
          post :complete, to: "sales_orders/completes#create"
          post :deliver, to: "sales_orders/deliveries#create"
          post :cancel, to: "sales_orders/cancels#create"
          get :split, to: "sales_orders/splits#new"
          post :split, to: "sales_orders/splits#create"
        end
      end
    end
  end

  namespace :factory, defaults: { department: "factory" } do
    root "dashboard#index"
    resources :formula_elements
    resources :formulas
    resources :making_orders
    resources :products
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "landing#index"
end
