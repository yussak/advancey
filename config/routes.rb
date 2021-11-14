Rails.application.routes.draw do
  root 'static_pages#home'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'inquiries#new'
  get '/signup', to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  # ゲストログイン
  post '/guest', to: 'guest_sessions#create'

  get 'auth/:provider/callback', to: 'sessions#google_login'
  get 'auth/failure', to: redirect('/')

  get 'likes/create'
  get 'likes/destroy'
  get 'password_resets/new'
  get 'password_resets/edit'

  resources :posts, only: %i[create new edit update destroy show] do
    resources :comments, only: %i[create destroy]
  end

  resources :relationships, only: %i[create destroy]
  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :sessions, only: %i[new create destroy]

  resources :inquiries, only: %i[new create]
  post 'confirm', to: 'inquiries#confirm', as: 'confirm'
  post 'back', to: 'inquiries#back', as: 'back'

  resources :password_resets, only: %i[new create edit update]

  resources :likes
end
