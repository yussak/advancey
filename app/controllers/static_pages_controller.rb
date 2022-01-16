class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @post = current_user.posts.build
      @all_posts = current_user.feed.where(privacy: false).page(params[:page]).per(9)
      @user_posts = current_user.posts.where(privacy: false).page(params[:page]).per(9)
      @want_posts = current_user.posts.where(privacy: false).where(tag: '実践したい').page(params[:page]).per(9)
      @doing_posts = current_user.posts.where(privacy: false).where(tag: '実践中').page(params[:page]).per(9)
      @master_posts = current_user.posts.where(privacy: false).where(tag: '身についた').page(params[:page]).per(9)
      # エラー出るので一時的に並び替えたもの↓
      @like_posts = current_user.like_posts.where(privacy: false).page(params[:page]).per(9)

      # # いいねをつけた順に表示
      # @like_posts = current_user.likes.order(created_at: 'DESC').map { |like| like.post }
    end
  end

  def about; end

  def contact; end
end
