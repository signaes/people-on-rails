Rails.application.routes.draw do
  root 'home#index'

  get  '/signup', to: 'people#new'
  post '/signup', to: 'people#create'

  resources :people
end
