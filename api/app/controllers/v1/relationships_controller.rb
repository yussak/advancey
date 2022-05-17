class V1::RelationshipsController < ApplicationController
  def create
    relationship = Relationship.create(
      follower_id: params[:follower_id],
      followed_id: params[:followed_id]
    )
    if relationship.save
      render json: relationship
    else
      render json: relationship.errors
    end
  end

  def destroy
    relationship = Relationship.find_by(
      follower_id: params[:follower_id],
      followed_id: params[:followed_id]
    )
    relationship.delete
    render json: relationship if relationship.destroy
  end
end
