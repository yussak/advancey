class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @post = current_user.posts.build
      @feed_items = current_user.feed.page(params[:page])
      @user_posts = current_user.posts.page(params[:page])
      @like_posts = current_user.like_posts.page(params[:page])
    end
  end

  def about; end

  def contact; end
end
