class V1::PostsController < ApplicationController
  def index
    post = Post.all
    render json: post
  end

  def create
    post = Post.new(post_params)
    if post.save
      render json: post
    else
      render json: post.errors
    end
  end

  private

  def post_params
    params.require(:post).permit(:content, :user_id)
  end
end
