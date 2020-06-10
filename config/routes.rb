# typed: strict
Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'application#status'

  namespace :api do
    resources :recipes, only: [:index]
    resources :ingredients, only: [:index]
  end
end
