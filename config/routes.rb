# typed: ignore
Rails.application.routes.draw do
  devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root to: 'application#status'

  namespace :api do
    resources :recipes, only: [:index]
    resources :ingredients, only: [:index]
  end
end
