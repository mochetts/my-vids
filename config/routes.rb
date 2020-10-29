Rails.application.routes.draw do
  root "videos#index"
  resources :videos, only: [:index, :show]
  resources :sessions, only: [:new, :create] do
    delete :logout, on: :collection, to: 'sessions#destroy'
  end
end
