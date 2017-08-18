Rails.application.routes.draw do
  root 'home#index'

  get '/signup', to: 'people#new'

  resources :people
end
