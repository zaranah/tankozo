Rails.application.routes.draw do
  devise_for :users
  root to: "restaurants#index"
  resources :users, only: [:edit, :update, :show] do
    resources :hopes, only: :index
    resources :likes, only: :index
    resources :users, only: :index
  end

  resources :restaurants do
    resources :comments, only: [:create, :destroy]
    resources :likes, only: [:create, :destroy]
    resources :hopes, only: [:create, :destroy]
    collection do
      get 'search'
      get 'intro'
    end
  end

  resources :tags, only: :show
  resources :tastes, only: :show
  
end