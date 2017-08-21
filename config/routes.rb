Rails.application.routes.draw do
  root   'home#index'

  get    '/signup',  to: 'people#new'
  post   '/signup',  to: 'people#create'
  get    '/profile',  to: 'people#show'

  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
end
