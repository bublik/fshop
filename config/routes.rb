require 'sidekiq/web'

Rails.application.routes.draw do
  root 'home#index'

  resources :products, only: [:index, :show] do
    collection do
      get :search, as: :search
      get 'tag/:tag_name(/:tag_type)', :action => :search, as: :tag
    end
  end

  get 'about' => 'home#about', as: :about
  get 'terms' => 'home#terms', as: :terms
  get 'privacy' => 'home#privacy', as: :privacy
  match 'contact_us' => 'home#contact_us', as: :contact_us, via: [:get, :post]
  get 'faq' => 'home#faq', as: :faq

  resources :blogs, only: [:index, :show] do
    collection do
      get 'page/:page', :action => :index
    end
  end

  get '/go(/:coupon_id)' => 'products#go', as: :go
  resources :questions, only: [:create]

  namespace :admin do
    resources :blogs, except: [:show]
    resources :short_urls, except: [:show]
    resources :shops, except: [:show] do
      resources :data_feeds, except: [:show]
    end

    resources :products, except: [:new, :show] do
      collection do
        get 'verification'
        get 'identification'
      end
    end

    resources :questions, except: [:show] do
      member do
        get 'mark_as_valid'
      end
    end
  end

  get '/admin', to: redirect('/admin/products')

  mount Ckeditor::Engine => '/ckeditor'
  mount Sidekiq::Web => '/sidekiq'

  Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
    [user, password] == [Rails.application.secrets.admin_user, Rails.application.secrets.admin_password]
  end

  match '/*seo_url(:format)', to: 'products#short', as: :seo_url, via: :get

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
