class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @post = current_user.posts.build
      @feed_items = current_user.feed.page(params[:page]).per(5)
    end
  end

  def about; end

  def contact; end

  # タグ一覧のため。仮
  def tag_list; end
end
