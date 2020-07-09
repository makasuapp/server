# typed: ignore
Rails.application.routes.draw do
  devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root to: 'application#status'

  namespace :api do
    resources :recipes, only: [:index]

    resources :op_days, only: [:index]
    post 'op_days/save_ingredients_qty', to: 'op_days#save_ingredients_qty'
    post 'op_days/save_prep_qty', to: 'op_days#save_prep_qty'

    resources :orders, only: [:index]
    post 'orders/:id/update_state', to: 'orders#update_state'
    post 'orders/update_items', to: 'orders#update_items'
  end
end
