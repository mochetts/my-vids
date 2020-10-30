Rails.application.routes.draw do
  root "library#index"
  resources :library, only: [:index]
  resources :videos, only: [:show]
  resources :sessions, only: [:new, :create] do
    delete :logout, on: :collection, to: 'sessions#destroy'
  end
end
