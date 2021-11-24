class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @post = current_user.posts.build
      # 重すぎるので一時的に数制限(limit以下を消せば解除できる)
      @all_posts = current_user.feed.limit(5)
      @user_posts = current_user.posts.limit(5)
      @want_posts = current_user.posts.where(action: '実践したい').limit(5)
      @doing_posts = current_user.posts.where(action: '実践中').limit(5)
      @master_posts = current_user.posts.where(action: '身についた').limit(5)
      @like_posts = current_user.like_posts.limit(5)
    end
  end

  def about; end

  def contact; end
end
