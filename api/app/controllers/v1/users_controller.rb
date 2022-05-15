class V1::UsersController < ApplicationController
  def index
    users = if params[:uid]
              User.find_by(uid: params[:uid])
            else
              User.all
            end
    render json: users, methods: :image_url
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
    done_posts = public_posts.where(tag: '実践済み')
    master_posts = public_posts.where(tag: 'やって良かった')
    topics = user.topics
    unsolved_topics = topics.where(solve_status: false)
    solved_topics = topics.where(solve_status: true)
    public_goals = user.goals.where(privacy: false)
    unachieved_goals = public_goals.where(achieve_status: false)
    achieved_goals = public_goals.where(achieve_status: true)
    render json: {
      user: user.as_json(methods: :image_url),
      posts: public_posts.as_json(methods: :image_url, except: :updated_at,
                                  include: { user: { methods: :image_url }, post_comments: { only: :id } }),
      doing_posts: doing_posts.as_json(methods: :image_url,
                                       include: { user: { methods: :image_url },
                                                  post_comments: { only: :id } }),
      want_posts: want_posts.as_json(methods: :image_url,
                                     include: { user: { methods: :image_url },
                                                post_comments: { only: :id } }),
      done_posts: done_posts.as_json(methods: :image_url,
                                     include: { user: { methods: :image_url },
                                                post_comments: { only: :id } }),
      master_posts: master_posts.as_json(include: { user: { methods: :image_url }, post_comments: { only: :id } }),
      topics: topics.as_json(methods: :image_url,
                             include: { user: { methods: :image_url },
                                        topic_comments: { only: :id } }),
      solved_topics: solved_topics.as_json(methods: :image_url,
                                           include: {
                                             user: { methods: :image_url }, topic_comments: { only: :id }
                                           }),
      unsolved_topics: unsolved_topics.as_json(methods: :image_url,
                                               include: {
                                                 user: { methods: :image_url }, topic_comments: { only: :id }
                                               }),
      goals: public_goals.as_json(methods: :image_url,
                                  include: { user: { methods: :image_url },
                                             goal_comments: { only: :id } }),
      achieved_goals: achieved_goals.as_json(methods: :image_url,
                                             include: {
                                               user: { methods: :image_url }, goal_comments: { only: :id }
                                             }),
      unachieved_goals: unachieved_goals.as_json(methods: :image_url,
                                                 include: {
                                                   user: { methods: :image_url }, goal_comments: { only: :id }
                                                 })
    }
  end

  def update
    user = User.find(params[:id])
    if user.update(user_params)
      render json: user, methods: :image_url
    else
      render json: user.errors
    end
  end

  def private_posts
    user = User.find(params[:id])
    private_posts = user.posts.where(privacy: true)
    doing_posts = private_posts.where(tag: '実践中')
    want_posts = private_posts.where(tag: '実践したい')
    done_posts = private_posts.where(tag: '実践済み')
    master_posts = private_posts.where(tag: 'やって良かった')
    render json: {
      user: user.as_json(methods: :image_url, only: %i[id name admin]),
      posts: private_posts.as_json(methods: :image_url, except: :updated_at,
                                   include: { user: { methods: :image_url }, post_comments: { only: :id } }),
      doing_posts: doing_posts.as_json(methods: :image_url,
                                       include: { user: { methods: :image_url }, post_comments: { only: :id } }),
      want_posts: want_posts.as_json(methods: :image_url,
                                     include: { user: { methods: :image_url }, post_comments: { only: :id } }),
      done_posts: done_posts.as_json(methods: :image_url,
                                     include: { user: { methods: :image_url }, post_comments: { only: :id } }),
      master_posts: master_posts.as_json(methods: :image_url,
                                         include: { user: { methods: :image_url }, post_comments: { only: :id } })
    }
  end

  def private_goals
    user = User.find(params[:id])
    private_goals = user.goals.where(privacy: true)

    render json: {
      user: user.as_json(methods: :image_url, only: %i[id name admin]),
      goals: private_goals.as_json(methods: :image_url, except: :updated_at,
                                   include: { user: { methods: :image_url }, goal_comments: { only: :id } })
    }
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :uid, :profile, :image, :admin)
  end
end
