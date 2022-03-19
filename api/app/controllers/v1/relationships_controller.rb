class V1::RelationshipsController < ApplicationController
  # リファクタリングしたい

  def index
    relationship = if params[:follower_id] && params[:followed_id]
                     Relationship.find_by(follower_id: params[:follower_id],
                                          followed_id: params[:followed_id])
                   elsif params[:follower_id]
                     Relationship.where(follower_id: params[:follower_id])
                   elsif params[:followed_id]
                     Relationship.where(followed_id: params[:followed_id])
                   else
                     []
                   end
    render json: relationship
  end

  def create
    relationship = Relationship.create(follower_id: params[:follower_id], followed_id: params[:followed_id])
    if relationship.save
      # if relationship.save!
      render json: relationship, status: :created
    else
      render json: relationship.errors
    end
  end

  def destroy
    if params[:follower_id] && params[:followed_id]
      relationship = Relationship.find_by(follower_id: params[:follower_id], followed_id: params[:followed_id])
      # relationship.destroy!
      relationship.destroy
      render json: { status: 'SUCCESS', message: '削除成功' }
    else
      render json: { status: 'NOT_FOUND', message: '削除失敗' }
    end
  end
end
