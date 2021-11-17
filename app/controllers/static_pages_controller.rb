class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @post = current_user.posts.build
      @feed_items = current_user.feed.page(params[:page]).per(5)
      @user_posts = current_user.posts.page(params[:page]).per(5)
      @like_posts = current_user.like_posts.page(params[:page]).per(5)
    end
  end

  def about; end

  def contact; end
end
