Rails.application.routes.draw do
  
  get 'reportoken_top/home'
  get 'reportoken_top/help'
  get 'reportoken_top/home'
  root 'reportoken_top#home'

  get '/help', to: 'reportoken_top#help'

  get  '/signup',  to: 'users#new'
  post '/signup',  to: 'users#create'

  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  
  resources :users
end
