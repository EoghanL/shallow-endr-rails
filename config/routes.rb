Rails.application.routes.draw do
  get '/login', to: 'sessions#new'
  post '/users/login', to: 'users#login'
  post '/users/signup', to: 'users#create'
  # get '/callback', to: 'users#callback'
  get '/search', to: 'artists#search'
  resources :songs
  resources :artists
  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
