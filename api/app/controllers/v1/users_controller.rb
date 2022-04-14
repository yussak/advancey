class V1::UsersController < ApplicationController
  def index
    users = if params[:uid]
              User.find_by(uid: params[:uid])
            else
              User.all
            end
    # 明らかに編集しないものだけ後で除外する
    # これだと画像編集が即時反映されない（ここが原因じゃないかもしれんが）
    # render json: users, methods: [:image_url]
    render json: users.to_json(methods: [:image_url])
    # こう書くと編集してもリロードで消える（onlyにないものーprofileとか）
    # render json: users.to_json(only: %i[id name email admin])
    # reset_digestなどあるのでそれも消す（migrate必要か）
  end

  def create
    user = User.new(user_params)
    if user.save
      # render json: user
      render json: user.to_json(methods: [:image_url])
      # render json: user, methods: [:image_url]
    else
      render json: user.errors
    end
  end

  def destroy
    user = User.find(params[:id])
    render json: user if user.destroy
  end

  def show
    user = User.find(params[:id])
    render json: user.to_json(methods: [:image_url],
                              include: [{ following: { only: [:id] } },
                                        { followers: { only: [:id] } }, { posts: { except: [:updated_at], include: { user: { only: :name } } } }])
  end

  # editいらんかも
  # もしかしたらいるかも
  # やはりいらなかった
  # def edit
  #   user = User.find(params[:id])
  #   render json: user
  # end

  def update
    user = User.find(params[:id])
    if user.update(user_params)
      # render json: user
      # こう書いたら非同期で画像編集できた
      render json: user, methods: [:image_url]
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
    params.require(:user).permit(:name, :email, :uid, :profile, :image, :admin)
  end
end
