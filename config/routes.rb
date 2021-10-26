Rails.application.routes.draw do
  root 'static_pages#home'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'inquiries#new'
  get '/signup', to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'

  get 'auth/:provider/callback', to: 'sessions#google_login'
  get 'auth/failure', to: redirect('/')

  # いいね一覧
  get 'likes/:id', to: 'users#like_list', as: :like_list

  delete '/logout', to: 'sessions#destroy'
  get 'likes/create'
  get 'likes/destroy'
  get 'password_resets/new'
  get 'password_resets/edit'
  resources :posts, only: %i[create destroy]
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
