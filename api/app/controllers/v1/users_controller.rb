class V1::UsersController < ApplicationController
  def index
    users = if params[:uid]
              User.find_by(uid: params[:uid])
            else
              User.all
            end
    render json: users
  end

  def create
    user = User.new(user_params)
    if user.save
      render json: user
    else
      render json: user.errors
    end
  end

  def show
    user = User.find(params[:id])
    # render json: user
    render json: user.to_json(include: [{ following: { only: [:id] } }, { followers: { only: [:id] } }])
  end

  # editいらんかも
  # def edit
  #   user = User.find(params[:id])
  #   render json: user
  # end

  def update
    user = User.find(params[:id])
    if user.update(user_params)
      render json: user
    else
      render json: user.errors
    end
  end

  def followers
    user  = User.find(params[:id])
    users = user.followers
    render json: users.to_json(only: %i[id name])
  end

  def following
    user  = User.find(params[:id])
    users = user.following
    render json: users.to_json(only: %i[id name])
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :uid, :profile)
  end
end
