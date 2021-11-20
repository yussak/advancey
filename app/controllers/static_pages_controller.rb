class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @post = current_user.posts.build
      # page不要なら削除
      @feed_items = current_user.feed.page(params[:page])
      @user_posts = current_user.posts.page(params[:page])
      @like_posts = current_user.like_posts
    end
  end

  def about; end

  def contact; end
end
