Rails.application.routes.draw do
  resources :shortens
  
  get '/:id', to: 'shortens#show'
  get '/:id/stats', to: 'shortens#stats'
  post '/shorten', to: 'shortens#create'

  root 'application#json'
  
end
