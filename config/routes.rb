Rails.application.routes.draw do
  get 'sessions/new'
  get 'users/new'
  root 'static_pages#home'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'
  get '/signup', to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  resources :users
  resources :posts, only: %i[create destroy]

  resources :inquiries, only: %i[new create]
  post 'confirm', to: 'inquiries#confirm', as: 'confirm'
  post 'back', to: 'inquiries#back', as: 'back'
  get 'done', to: 'inquiries#done', as: 'done'
end
