Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/cameras', to: 'cameras#index'
  get '/cameras/:id', to: 'cameras#show'
  post '/cameras', to: 'cameras#create'
  delete '/cameras', to: 'cameras#clear'
end
