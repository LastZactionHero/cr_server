CrServer::Application.routes.draw do
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'
  devise_for :users

  root :to => "ingredients#index"
  match "/d", to: "ingredients#index"
  match "/api", to: "api_documentation#index"
  
  resources :landing, only: [:index] do
    collection do
      post :signup
    end
  end

  devise_for :users

  resources :labels, only: [:create, :show] do
    member do
      put 'rate'
    end
  end

  resources :ingredients, only: [:index, :show, :edit, :update] do
    collection do
      get 'search'
      get 'proofread'
      get 'unwritten'
    end

    member do
      delete 'delete'
      put 'proof'
    end
  end

  resources :ingredient_of_the_weeks, only: [:index] do
    collection do
      get 'current'
    end
    member do
      put 'distribute'
    end
  end

  resources :resources, only: [:index] do
    member do
      get 'edit_ingredient'
      put 'update_ingredient'
    end
  end

  match "/sitemap.:format" => 'sitemap#sitemap'

  match '*path' => 'ingredients#index'

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

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
