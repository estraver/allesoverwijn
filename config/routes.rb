Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'home#index'
  resources :users, only: [:show, :edit, :update, :index] do
    resource :confirmation, only: [:show]
    resources :profiles, only: [:show, :edit] do
      scope module: :profiles do
        resource :bio, only: [:edit, :update, :show]
        resource :contact, only: [:edit, :update, :show]
        resource :activities, only: [:show]
        resource :favorites, only: [:edit, :update, :show]
        resource :friends, only: [:edit, :update, :show]
        resource :photo, only: [:create]
      end
      resource :network_accounts
    end
  end
  resources :blogs do
    patch :publish, on: :member
    post :upload, on: :member, as: :upload_picture
    get :close, :preview, on: :member
  end

  resource :session, only: [:new, :create, :destroy]
  resource :registration

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
