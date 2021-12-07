class LikesController < ApplicationController
  before_action :logged_in_user, only: %i[create destroy]

  def create
    @post = Post.find(params[:post])
    current_user.like(@post)
  end

  def destroy
    @post = Like.find(params[:id]).post
    current_user.unlike(@post)
  end
end
