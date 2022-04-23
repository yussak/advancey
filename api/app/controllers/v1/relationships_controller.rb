class V1::RelationshipsController < ApplicationController
  # before_action :set_user
  # リファクタリングしたい
  def index
    # render json: u
    user = User.find_by(params[:user_id])
    r = Relationship.all
    # render json: user
    # ur = user.r
    # render json: ur
    render json: r.as_json(only: %i[id followed_id follower_id])
  end

  # def index
  #   relationship = if params[:follower_id] && params[:followed_id]
  #                    Relationship.find_by(follower_id: params[:follower_id],
  #                                         followed_id: params[:followed_id])
  #                  elsif params[:follower_id]
  #                    Relationship.where(follower_id: params[:follower_id])
  #                  elsif params[:followed_id]
  #                    Relationship.where(followed_id: params[:followed_id])
  #                  else
  #                    []
  #                  end
  #   render json: relationship
  # end

  def create
    # relationship = Relationship.create(follower_id: params[:follower_id], followed_id: params[:followed_id])
    # # if relationship.save
    # if relationship.save!
    #   render json: relationship, status: :created
    # else
    #   render json: relationship.errors
    # end
    @current_user = User.find(params[:follower_id])
    @other_user = User.find(params[:followed_id])

    @current_user.follow(@other_user)
    render json: @other_user
  end

  def destroy
    #   if params[:follower_id] && params[:followed_id]
    #     relationship = Relationship.find_by(follower_id: params[:follower_id], followed_id: params[:followed_id])
    #     relationship.destroy!
    #     # relationship.destroy
    #     render json: { status: 'SUCCESS', message: '削除成功' }
    #   else
    #     render json: { status: 'NOT_FOUND', message: '削除失敗' }
    #   end
    @current_user = User.find(params[:follower_id])
    @other_user = User.find(params[:followed_id])

    @current_user.unfollow(@other_user)
    render json: @other_user
  end

  private

  def set_user
    # @current_user = User.find(params[:follower_id])
    # @other_user = User.find(params[:followed_id])

    @current_user = User.find_by(params[:follower_id])
    @other_user = User.find_by(params[:followed_id])
  end
end
