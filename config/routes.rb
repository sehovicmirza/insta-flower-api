Rails.application.routes.draw do
  resources :users, only: :create

  resources :flowers, only: :index do
    resources :sightings, only: %i[index create]
  end

  resources :sightings, only: :destroy

  post '/login', to: 'users#login'
end
