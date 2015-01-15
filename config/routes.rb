Rails.application.routes.draw do
  resources :shortens

  root 'application#json'
end
