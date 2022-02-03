Rails.application.routes.draw do
  devise_for :users
  root to: "restaurants#index"
  resources :users, only: [:edit, :update, :show]

  resources :restaurants do
    resources :comments, only: :create
    resources :likes, only: [:create, :destroy]
    resources :hopes, only: [:create, :destroy]
  end
  
end