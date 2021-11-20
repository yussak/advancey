class LikesController < ApplicationController
  def create
    # current_user.like_this(clicked_post)
    # redirect_back(fallback_location: root_path)

    @post = Post.find(params[:post])
    current_user.like(@post)
    # respond_to do |format|
    #   # format.html { redirect_to root_path }
    #   format.html { redirect_back(fallback_location: root_path) }
    #   format.js
    # end
  end

  def destroy
    # current_user.likes.find_by(post_id: params[:post_id]).destroy
    # redirect_back(fallback_location: root_path)

    @post = Like.find(params[:id]).post
    current_user.unlike(@post)
    # respond_to do |format|
    #   # format.html { redirect_to root_path }
    #   format.html { redirect_back(fallback_location: root_path) }
    #   format.js
    # end
  end

  # def clicked_post
  #   Post.find(params[:post_id])
  # end
end
