Rails.application.routes.draw do
  root   'home#index'

  get    '/signup',         to: 'people#new'
  post   '/signup',         to: 'people#create'
  get    '/profile',        to: 'people#show'
  get    '/profile/edit',   to: 'people#edit'
  patch  '/profile/edit',   to: 'people#update'
  delete '/delete_account', to: 'people#destroy'

  get    '/login',          to: 'sessions#new'
  post   '/login',          to: 'sessions#create'
  delete '/logout',         to: 'sessions#destroy'
end
