Comman::Application.routes.draw do


  namespace :business do
    resources :clients do
      get :autocomplete, :on => :collection
    end
    resources :delivery_notes do
      member do
        post :liberate
        post :close
      end
      collection do
        get :delivery_note_item
        get :client
      end
    end
    root :to => 'dashboard#index'
  end

  namespace :factory do
    resources :products do
      get :autocomplete, :on => :collection
    end
    resources :formula_elements do
      get :join, :on => :collection, :action => "preview_join"
      post :join, :on => :collection
      get :autocomplete, :on => :collection
      get :formulas, :on => :member
      get :report, :on => :collection
    end
    resources :formulas do
      resources :formula_items
      get :formula_item, :on => :collection
      get :products, :on => :member
    end
    resources :making_orders do
      get :making_order_item, :on => :collection
    end
    root :to => 'dashboard#index'
  end

  root :to => 'dashboard#index'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
