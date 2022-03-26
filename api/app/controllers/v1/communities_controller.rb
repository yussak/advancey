class V1::CommunitiesController < ApplicationController
  def index
    communities = Community.all
    render json: communities.to_json(except: %i[created_at updated_at], include: [{ users: { only: [:id] } }])
  end

  def create
    community = Community.new(community_params)
    if community.save
      render json: community
    else
      render json: community.errors
    end
  end

  def show
    community = Community.find(params[:id])
    render json: community.to_json(except: %i[created_at updated_at], include: { users: { only: [:id] } })
  end

  private

  def community_params
    params.require(:community).permit(:user_id, :name)
  end
end
