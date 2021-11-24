class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @post = current_user.posts.build
      # @all_posts = current_user.feed # 自分・フォロー中の投稿
      # @user_posts = current_user.posts.all # 自分の投稿
      # @want_posts = current_user.posts.where(action: '実践したい')
      # @doing_posts = current_user.posts.where(action: '実践中')
      # @master_posts = current_user.posts.where(action: '身についた')
      # @like_posts = current_user.like_posts

      # 重すぎるので一時的に数制限
      @all_posts = current_user.feed.limit(5)
    end
  end

  def about; end

  def contact; end
end
