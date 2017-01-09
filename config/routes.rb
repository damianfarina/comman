Rails.application.routes.draw do
  namespace :factory do
    resources :formulas
    resources :products do
      get :autocomplete, :on => :collection
    end
    resources :posts
    resources :formula_elements do
      get :join, :on => :collection, :action => "preview_join"
      post :join, :on => :collection
      get :autocomplete, :on => :collection
      get :formulas, :on => :member
      get :products, :on => :member
      get :report, :on => :collection
    end
  end
end
