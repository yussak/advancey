class LikesController < ApplicationController
  def create
    current_user.like_this(clicked_post)
    redirect_back(fallback_location: root_path)
  end

  def destroy
    current_user.likes.find_by(post_id: params[:post_id]).destroy
    redirect_back(fallback_location: root_path)
  end

  private

  def clicked_post
    Post.find(params[:post_id])
  end
end
