class PostsController < ApplicationController
  before_action :logged_in_user, only: %i[create destroy]

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:success] = '投稿追加しました！'
      redirect_to root_url
    else
      # @feed_items = current_user.feed.paginate(page: params[:page])
      @feed_items = current_user.feed
      render 'static_pages/home'
    end
  end

  def destroy; end

  private

  def post_params
    params.require(:post).permit(:content)
  end
end
