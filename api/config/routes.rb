Rails.application.routes.draw do
  # root 'static_pages#home'
  root to: 'rails/welcome#index'
  namespace :v1 do
    resources :users, only: %i[create index show]
    resources :posts, only: %i[index create destroy edit update show] do
      # resources :comments, only: %i[create destroy]
      resources :comments, only: %i[create destroy index] # 試し
      # この書き方だとすべてのコメント一覧がposts/id/comments下に来るので、indexだけ個別にgetなどと書くかも
      # post '/comments', to: 'comments#create'
    end
    resources :topics # 後でonly使ってアクション絞る
  end
  # get '/about', to: 'static_pages#about'
  # get '/contact', to: 'inquiries#new'
  # # get '/signup', to: 'users#new'
  # # get '/login', to: 'sessions#new'
  # # post '/login', to: 'sessions#create'
  # # delete '/logout', to: 'sessions#destroy'

  # # ゲストログイン
  # post '/guest', to: 'guest_sessions#create'

  # get 'likes/create'
  # get 'likes/destroy'
  # get 'password_resets/new'
  # get 'password_resets/edit'

  # # 自分だけ閲覧出来る投稿一覧
  # get 'private_posts', to: 'posts#private_index'

  # # resources :posts, only: %i[create new edit update destroy show] do
  # #   resources :comments, only: %i[create destroy]

  # #   collection do
  # #     get 'search'
  # #   end
  # # end

  # resources :relationships, only: %i[create destroy]

  # # resources :users do
  # #   member do
  # #     get :following, :followers
  # #   end

  # #   collection do
  # #     get 'search'
  # #   end
  # # end
  # resources :sessions, only: %i[new create destroy]

  # resources :inquiries, only: %i[new create]
  # post 'confirm', to: 'inquiries#confirm', as: 'confirm'
  # post 'back', to: 'inquiries#back', as: 'back'

  # resources :password_resets, only: %i[new create edit update]

  # resources :likes

  # resources :topics do
  #   resources :topic_comments, only: %i[create destroy]
  # end
end
