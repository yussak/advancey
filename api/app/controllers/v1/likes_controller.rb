class V1::LikesController < ApplicationController
  def index
    render json: Like.filter_by_post(params[:post_id]).select(:id, :user_id, :post_id)
  end

  def create
    like = Like.new(like_params)
    render status: :created, json: true if like.save
  end

  def destroy
    Like.find_by(params[:post_id]).destroy
    head :ok
  end

  private

  def like_params
    params.require(:like).permit(:user_id, :post_id)
  end
end
