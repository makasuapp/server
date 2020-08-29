# typed: ignore
Rails.application.routes.draw do
  devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root to: 'application#status'

  namespace :api do
    resources :users, only: [:create, :show]
    post 'users/login', to: 'users#login'
    post 'users/reset_password', to: 'users#reset_password'
    post 'users/request_reset', to: 'users#request_reset'
    post 'users/verify', to: 'users#verify'

    resources :recipes, only: [:index]

    resources :op_days, only: [:index]
    post 'op_days/save_ingredients_qty', to: 'op_days#save_ingredients_qty'
    post 'op_days/save_prep_qty', to: 'op_days#save_prep_qty'

    resources :orders, only: [:create, :index]
    post 'orders/:id/update_state', to: 'orders#update_state'
    post 'orders/update_items', to: 'orders#update_items'

    resources :procurement, only: [:index]
    post 'procurement/update_items', to: 'procurement#update_items'

    resources :predicted_orders, only: [:index]
    post 'predicted_orders/for_date', to: 'predicted_orders#update_for_date'

  end

  post 'wix/orders', to: 'wix#orders_webhook'
end
