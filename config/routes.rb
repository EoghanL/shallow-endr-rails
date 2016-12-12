Rails.application.routes.draw do
  resources :rankings
  resources :users_artists
  resources :future_songs
  get '/login', to: 'sessions#new'
  get 'users/getUserId', to: 'users#getUserId'
  post '/sessions/login', to: 'sessions#login'
  post '/users/signup', to: 'users#create'
  post '/users/addSong', to: 'users#add_song'
  post '/future_songs/:id', to: 'future_songs#destroy'
  # get '/callback', to: 'users#callback'
  get '/search', to: 'artists#search'
  resources :songs
  resources :artists
  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
