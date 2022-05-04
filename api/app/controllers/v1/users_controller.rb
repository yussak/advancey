class V1::UsersController < ApplicationController
  def index
    users = if params[:uid]
              User.find_by(uid: params[:uid])
            else
              User.all
            end
    render json: users, methods: :image_url # 絞りたい
  end

  def create
    user = User.new(user_params)
    if user.save
      render json: user, methods: :image_url
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
    master_posts = public_posts.where(tag: 'やって良かった')
    topics = user.topics
    unsolved_topics = topics.where(solve_status: false)
    solved_topics = topics.where(solve_status: true)
    goals = user.goals
    unachieved_goals = goals.where(achieve_status: false)
    achieved_goals = goals.where(achieve_status: true)
    render json: { user: user.as_json(methods: :image_url), posts: public_posts.as_json(methods: :image_url, except: :updated_at, include: { user: { methods: :image_url } }), doing_posts: doing_posts.as_json(methods: :image_url, include: { user: { methods: :image_url } }), want_posts: want_posts.as_json(methods: :image_url, include: { user: { methods: :image_url } }), master_posts: master_posts.as_json(include: { user: { methods: :image_url } }),
                   topics: topics.as_json(methods: :image_url, include: { user: { methods: :image_url } }), solved_topics: solved_topics.as_json(methods: :image_url, include: { user: { methods: :image_url } }),
                   unsolved_topics: unsolved_topics.as_json(methods: :image_url, include: { user: { methods: :image_url } }), goals: goals.as_json(methods: :image_url, include: { user: { methods: :image_url } }),
                   achieved_goals: achieved_goals.as_json(methods: :image_url, include: { user: { methods: :image_url } }), unachieved_goals: unachieved_goals.as_json(methods: :image_url, include: { user: { methods: :image_url } }) }
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
    master_posts = private_posts.where(tag: 'やって良かった')
    render json: { user: user.as_json(methods: :image_url, only: %i[id name admin]), doing_posts: doing_posts.as_json(methods: :image_url, include: { user: { methods: :image_url, only: %i[id name admin] } }), want_posts: want_posts.as_json(methods: :image_url, include: { user: { methods: :image_url, only: %i[id name admin] } }), master_posts: master_posts.as_json(methods: :image_url, include: { user: { methods: :image_url, only: %i[id name admin] } }),
                   posts: private_posts.as_json(methods: :image_url, except: :updated_at, include: { user: { methods: :image_url, only: %i[id name admin] } }) }
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :uid, :profile, :image, :admin)
  end
end
