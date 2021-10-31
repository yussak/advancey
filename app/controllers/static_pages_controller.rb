class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @post = current_user.posts.build
      # @feed_items = current_user.feed.paginate(page: params[:page], per_page: 5)
      # @feed_items = current_user.feed.page(page: params[:page], per_page: 5)
      # @feed_items = current_user.feed.page(params[:page])
      @feed_items = current_user.feed.page(params[:page]).per(2)

    end
  end

  def about; end

  def contact; end
end
