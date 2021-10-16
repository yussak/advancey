Rails.application.routes.draw do
  get 'password_resets/new'
  get 'password_resets/edit'
  # get 'sessions/new'
  # get 'users/new'
  root 'static_pages#home'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'inquiries#new'
  get '/signup', to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  resources :posts, only: %i[create destroy]
  resources :relationships, only: %i[create destroy]
  resources :users do
    member do
      get :following, :followers
    end
  end

  resources :inquiries, only: %i[new create]
  post 'confirm', to: 'inquiries#confirm', as: 'confirm'
  post 'back', to: 'inquiries#back', as: 'back'

  resources :password_resets, only: %i[new create edit update]
end
