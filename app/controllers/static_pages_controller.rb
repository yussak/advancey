class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @post = current_user.posts.build
      @all_posts = current_user.feed # 自分・フォロー中の投稿

      # page消したい
      @user_posts = current_user.posts.page(params[:page])
      # @user_posts = current_user.posts

      @want_posts = current_user.posts.where(action: '実践したい')
      @doing_posts = current_user.posts.where(action: '実践中')
      @master_posts = current_user.posts.where(action: '身についた')
      @like_posts = current_user.like_posts
    end
  end

  def about; end

  def contact; end
end
