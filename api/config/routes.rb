Rails.application.routes.draw do
  mount ActionCable.server => '/cable'
  namespace :v1 do
    # ECSデプロイ ヘルスチェック用
    get 'health_check', to: 'health_check#index'

    # TOPページ用
    get 'top_page/posts', to: 'top_page#post_index'
    get 'top_page/topics', to: 'top_page#topic_index'
    get 'top_page/goals', to: 'top_page#goal_index'
    get 'top_page/communities', to: 'top_page#community_index'

    # フォロー（試し）
    resources :relationships
    # resources :relationships, only: %i[create destroy]

    # 運営からのお知らせ
    resources :news, only: %i[index create destroy]

    # ユーザー
    resources :users, only: %i[index create destroy show update]

    # 自分だけ閲覧できるメモ一覧
    get 'users/:id/private_posts', to: 'users#private_posts'
    # 自分だけ閲覧できる目標一覧
    get 'users/:id/private_goals', to: 'users#private_goals'

    # メモ
    resources :posts, only: %i[index create destroy show update] do
      resources :post_comments, only: %i[create destroy update]
    end

    # 質問
    resources :topics, only: %i[index create destroy show update] do
      resources :topic_comments, only: %i[create destroy update]
    end

    # 目標
    resources :goals, only: %i[index create destroy show update] do
      resources :goal_comments, only: %i[create destroy update]
    end

    # コミュニティ
    resources :communities, only: %i[index create destroy show] do
      resources :belongings, only: %i[index create]
    end
  end
end
