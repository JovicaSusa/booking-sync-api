Rails.application.routes.draw do
  post 'token' => 'authentication#create'
  resources :users, only: [:create]
  resources :rentals
end
