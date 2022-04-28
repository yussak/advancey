class V1::UsersController < ApplicationController
  def index
    users = if params[:uid]
              User.find_by(uid: params[:uid])
            else
              User.all
            end
    render json: users.to_json(methods: [:image_url], include: [{ goals: { only: %i[content created_at] } }])
  end

  def create
    user = User.new(user_params)
    if user.save
      render json: user.to_json(methods: [:image_url])
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
                              include: [{ posts: { except: [:updated_at], include: { user: { only: :name } } } },
                                        { goals: { include: { user: { only: :name } } } }])
  end

  def update
    user = User.find(params[:id])
    if user.update(user_params)
      render json: user.as_json(methods: [:image_url])
    else
      render json: user.errors
    end
  end

  # def followers
  #   user  = User.find(params[:id])
  #   users = user.followers
  #   render json: users.to_json(only: %i[id name])
  # end

  # def following
  #   user  = User.find(params[:id])
  #   users = user.following
  #   render json: users.to_json(only: %i[id name])
  # end

  # postsコントローラに書き換えたい
  def private_index
    user = User.find(params[:id])
    private_posts = user.posts.where(privacy: true)
    render json: private_posts
    # render json: private_posts.to_json(include: { user: { only: :name } })
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :uid, :profile, :image, :admin)
  end
end
