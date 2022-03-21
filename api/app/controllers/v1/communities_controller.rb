class V1::CommunitiesController < ApplicationController
  def index
    communities = Community.all
    render json: communities
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
    render json: community
  end

  private

  def community_params
    params.require(:community).permit(:name)
  end
end
