class V1::TopPageController < ApplicationController
  def post_index
    public_posts = Post.where(privacy: false)
    latest_posts = public_posts.limit(6)
    doing_posts = latest_posts.where(tag: '実践中')
    want_posts = latest_posts.where(tag: '実践したい')
    master_posts = latest_posts.where(tag: 'やって良かった')
    render json: {
      posts: latest_posts.as_json(methods: :image_url, except: :updated_at,
                                  include: { user: { methods: :image_url, only: %i[id name admin] } }),
      doing_posts: doing_posts.as_json(methods: :image_url,
                                       include: { user: { methods: :image_url, only: %i[id name admin] } }),
      want_posts: want_posts.as_json(methods: :image_url,
                                     include: { user: { methods: :image_url, only: %i[id name admin] } }),
      master_posts: master_posts.as_json(methods: :image_url,
                                         include: { user: { methods: :image_url, only: %i[id name admin] } })
    }
  end

  def topic_index
    topics = Topic.limit(6)
    unsolved_topics = topics.where(solve_status: false)
    solved_topics = topics.where(solve_status: true)
    render json: {
      topics: topics.as_json(methods: :image_url, include: { user: { methods: :image_url, only: %i[id name admin] } }),
      solved_topics: solved_topics.as_json(methods: :image_url,
                                           include: { user: { methods: :image_url, only: %i[id name admin] } }),
      unsolved_topics: unsolved_topics.as_json(methods: :image_url,
                                               include: { user: { methods: :image_url, only: %i[id name admin] } })
    }
  end

  def goal_index
    goals = Goal.limit(6)
    unachieved_goals = goals.where(achieve_status: false)
    achieved_goals = goals.where(achieve_status: true)
    render json: {
      goals: goals.as_json(methods: :image_url, include: { user: { methods: :image_url, only: %i[id name admin] } }),
      achieved_goals: achieved_goals.as_json(methods: :image_url,
                                             include: { user: { methods: :image_url, only: %i[id name admin] } }),
      unachieved_goals: unachieved_goals.as_json(methods: :image_url,
                                                 include: { user: { methods: :image_url, only: %i[id name admin] } })
    }
  end

  def community_index
    communities = Community.limit(6)
    render json: communities.as_json(except: %i[created_at updated_at], include: [{ users: { only: :id } }])
  end
end
