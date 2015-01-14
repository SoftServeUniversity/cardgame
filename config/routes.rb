Rails.application.routes.draw do
  get 'main/index'

  devise_for :users
  get 'users/:id' , :controller => 'users', :action => 'show',  :as => 'user_show'
  get 'users/:id/edit' , :controller => 'users', :action => 'edit',  :as => 'user_edit'
  put 'users/:id' , :controller => 'users', :action => 'update',  :as => 'user_update' 

  get 'users' , :controller => 'users', :action => 'statistic',  :as => 'statistic'

  get 'games/:id/my_game', :controller => 'games', :action => 'show', :as => 'my_game'
  
  post 'games/:id/put_card', :controller => 'games', :action => 'put_card', :as => 'put_card'
  post 'games/:id/end_turn', :controller => 'games', :action => 'end_turn', :as => 'end_turn'
  post 'games/:id/end_game', :controller => 'games', :action => 'end_game', :as => 'end_game'
  post 'games/:id/update', :controller => 'games', :action => 'update', :as => 'update'

  resources :games

  get 'games/:id', :controller => 'games', :action => 'refresh_show', :as => 'refresh_show'


  # get "assets/:name" , :controller => 'assets', :action => 'get_img', :as => 'get_img'

  root 'main#index'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
