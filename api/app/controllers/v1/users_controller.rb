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
    public_posts = user.posts.where(privacy: false)
    doing_posts = public_posts.where(tag: '実践中')
    want_posts = public_posts.where(tag: '実践したい')
    master_posts = public_posts.where(tag: '身についた')
    goals = user.goals
    render json: { user: user.as_json(methods: :image_url), posts: public_posts.as_json(methods: :image_url, except: [:updated_at], include: { user: { methods: :image_url, only: :name } }), doing_posts: doing_posts.as_json(methods: :image_url, include: { user: { methods: :image_url, only: :name } }), want_posts: want_posts.as_json(methods: :image_url, include: { user: { methods: :image_url, only: :name } }), master_posts: master_posts.as_json(include: { user: { methods: :image_url, only: :name } }),
                   goals: goals.as_json(include: { user: { only: :name } }) }
  end

  def update
    user = User.find(params[:id])
    if user.update(user_params)
      render json: user, methods: [:image_url]
    else
      render json: user.errors
    end
  end

  def private_index
    user = User.find(params[:id])
    private_posts = user.posts.where(privacy: true)
    doing_posts = private_posts.where(tag: '実践中')
    want_posts = private_posts.where(tag: '実践したい')
    master_posts = private_posts.where(tag: '身についた')
    render json: { user: user.as_json(methods: :image_url, only: :name), doing_posts: doing_posts.as_json(methods: :image_url, include: { user: { methods: :image_url, only: :name } }), want_posts: want_posts.as_json(methods: :image_url, include: { user: { methods: :image_url, only: :name } }), master_posts: master_posts.as_json(methods: :image_url, include: { user: { methods: :image_url, only: :name } }),
                   posts: private_posts.as_json(methods: :image_url, except: [:updated_at], include: { user: { methods: :image_url, only: :name } }) }
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :uid, :profile, :image, :admin)
  end
end
