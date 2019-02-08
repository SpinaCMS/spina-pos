Spina::Engine.routes.draw do
  namespace :shop, path: '' do
    namespace :admin, path: Spina.config.backend_path do
      scope '/shop' do
        resources :shifts, only: [:index, :show]
      end
    end
  end
end

Spina::Pos::Engine.routes.draw do
  get :login, to: 'sessions#new'
  post :login, to: 'sessions#create', as: 'post_login'
  get :logout, to: 'sessions#destroy'

  resources :orders, only: [:new, :index, :show, :update] do
    resources :order_items, only: [:destroy]

    collection do
      post :add_product, format: :js
      post :add_product_bundle, format: :js
      get :scanned
      get :gift_card
      get :discount
      post :add_gift_card
      post :add_discount
      delete :remove_gift_card
      delete :remove_discount
    end
  end

  resources :products, only: [:index, :show] do
    collection do
      post :search
    end
  end

  resources :product_categories, only: [:show]
  resources :product_collections, only: [:index, :show]
  resources :product_bundles

  resources :checkout do
    collection do
      patch :update
      post :confirm
      get :cash_payment
      get :pin_payment
      get :finished
    end
  end
  resource :settings do
    resource :printer
    resources :orders do
      member do
        get :print
      end
    end
    resources :shifts
  end
end
