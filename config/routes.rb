Rails.application.routes.draw do
  devise_for :users
  root to: "restaurants#index"
  resources :users, only: [:edit, :update, :show]
  resources :restaurants
end
