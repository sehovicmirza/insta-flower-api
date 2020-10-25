Rails.application.routes.draw do
  resources :users, only: :create
  resources :flowers, only: :index

  post '/login', to: 'users#login'
end
