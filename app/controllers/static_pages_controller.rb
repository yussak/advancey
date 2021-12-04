class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @post = current_user.posts.build
      @all_posts = current_user.feed.page(params[:page]).per(5)
      @user_posts = current_user.posts.page(params[:page]).per(5)
      @want_posts = current_user.posts.where(action: '実践したい').page(params[:page]).per(5)
      @doing_posts = current_user.posts.where(action: '実践中').page(params[:page]).per(5)
      @master_posts = current_user.posts.where(action: '身についた').page(params[:page]).per(5)
      # ↓なんかエラー出るので一時的に並び替え解除(map解除しないといけない)
      @like_posts = current_user.like_posts.page(params[:page]).per(5)

      # # いいねをつけた順に表示
      # @like_posts = current_user.likes.order(created_at: 'DESC').map { |like| like.post }
    end
  end

  def about; end

  def contact; end
end
