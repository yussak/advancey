Rails.application.routes.draw do
  mount ActionCable.server => '/cable'
  # アクション絞るのは後で（最終的に使ってるやつだけonlyに書く）
  namespace :v1 do
    # ECSデプロイ ヘルスチェック用
    get 'health_check', to: 'health_check#index'

    resources :users
    # resources :users do
    #   resources :goals
    # end
    # resources :users, only: %i[create index show edit update]

    get 'private_posts', to: 'posts#private_index' # 自分だけ閲覧出来る投稿一覧
    # resources :users, only: %i[create index show edit update] do
    #   get 'private_posts', to: 'posts#private_index' # 自分だけ閲覧出来る投稿一覧
    # end

    resources :relationships
    # resources :relationships, only: %i[create destroy]
    # resources :relationships, only: %i[create destroy index]

    resources :users do
      member do
        get :following, :followers
      end
    end

    # 目標
    resources :goals do
      resources :goal_comments
    end

    # コミュニティ
    resources :communities do
      resources :belongings
      # メッセージ
      resources :messages
    end

    # resources :posts, only: %i[index create destroy edit update show] do
    resources :posts do
      resources :comments
      # resources :comments, only: %i[create destroy]
    end
    resources :topics do # 後でonly使ってアクション絞る
      resources :topic_comments, only: %i[create destroy]
      # resources :topic_comments, only: %i[create destroy]
    end
  end

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
end
