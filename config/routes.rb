# typed: ignore
Rails.application.routes.draw do
  devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root to: 'application#status'

  namespace :api do
    resources :recipes, only: [:index]
    resources :inventory, only: [:index]
    post 'inventory/save_qty', to: 'inventory#save_qty'
  end
end
