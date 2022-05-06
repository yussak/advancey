class V1::BelongingsController < ApplicationController
  def index
    belonging = Belonging.all
    render json: belonging.as_json(except: %i[created_at updated_at])
  end

  def create
    belonging = Belonging.create(community_id: belonging_params[:community_id], user_id: belonging_params[:user_id])
    if belonging.save!
      render json: belonging
    else
      render json: belonging.errors
    end
  end

  private

  def belonging_params
    params.require(:belonging).permit(:community_id, :user_id)
  end
end
