class V1::BelongingsController < ApplicationController
  def create
    belonging = Belonging.create(community_id: belonging_params[:community_id], user_id: belonging_params[:user_id])
    render json: belonging
  end

  private

  def belonging_params
    params.permit(:community_id, :user_id)
  end
end
