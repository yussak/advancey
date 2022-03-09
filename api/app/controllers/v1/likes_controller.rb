class V1::LikesController < ApplicationController
  def index
    # render json: Like.filter_by_post(params[:post_id]).select(:id, :user_id, :post_id) # これ怪しい
    user = User.find_by(id: '3')
    render json: user.likes # 空配列
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
