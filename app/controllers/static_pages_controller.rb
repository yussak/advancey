class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @post = current_user.posts.build
      # 重すぎるので一時的に数制限(limit以下を消せば解除できる)
      # @all_posts = current_user.feed.limit(10)
      # @user_posts = current_user.posts.limit(10)
      # @want_posts = current_user.posts.where(action: '実践したい').limit(10)
      # @doing_posts = current_user.posts.where(action: '実践中').limit(10)
      # @master_posts = current_user.posts.where(action: '身についた').limit(10)
      # # @like_posts = current_user.like_posts.limit(10)
      # # いいねをつけた順に表示
      # @like_posts = current_user.likes.order(created_at: 'DESC').limit(10).map { |like| like.post }

      @all_posts = current_user.feed.page(params[:page]).without_count.per(5)
      @user_posts = current_user.posts.page(params[:page]).without_count.per(5)
      @want_posts = current_user.posts.where(action: '実践したい').page(params[:page]).without_count.per(5)
      @doing_posts = current_user.posts.where(action: '実践中').page(params[:page]).without_count.per(5)
      @master_posts = current_user.posts.where(action: '身についた').page(params[:page]).without_count.per(5)
      # ↓なんかエラー出るので一時的に並び替え解除
      @like_posts = current_user.like_posts.page(params[:page]).without_count.per(5)
    end
  end

  def about; end

  def contact; end
end
