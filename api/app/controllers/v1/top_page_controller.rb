class V1::TopPageController < ApplicationController
  def post_index
    public_posts = Post.where(privacy: false)
    latest_posts = public_posts.limit(6)
    doing_posts = latest_posts.where(tag: '実践中')
    want_posts = latest_posts.where(tag: '実践したい')
    done_posts = latest_posts.where(tag: '実践済み')
    master_posts = latest_posts.where(tag: 'やって良かった')
    render json: {
      posts: latest_posts.as_json(methods: :image_url, except: :updated_at,
                                  include: { user: { methods: :image_url, only: %i[id name admin] }, post_comments: { only: :id } }),
      doing_posts: doing_posts.as_json(methods: :image_url,
                                       include: { user: { methods: :image_url },
                                                  post_comments: { only: :id } }),
      want_posts: want_posts.as_json(methods: :image_url,
                                     include: { user: { methods: :image_url },
                                                post_comments: { only: :id } }),
      master_posts: master_posts.as_json(methods: :image_url,
                                         include: { user: { methods: :image_url },
                                                    post_comments: { only: :id } }),
      done_posts: done_posts.as_json(methods: :image_url,
                                     include: { user: { methods: :image_url },
                                                post_comments: { only: :id } })
    }
  end

  def topic_index
    topics = Topic.limit(6)
    unsolved_topics = topics.where(solve_status: false)
    solved_topics = topics.where(solve_status: true)
    render json: {
      topics: topics.as_json(methods: :image_url,
                             include: { user: { methods: :image_url },
                                        topic_comments: { only: :id } }),
      solved_topics: solved_topics.as_json(methods: :image_url,
                                           include: { user: { methods: :image_url }, topic_comments: { only: :id } }),
      unsolved_topics: unsolved_topics.as_json(methods: :image_url,
                                               include: { user: { methods: :image_url },
                                                          topic_comments: { only: :id } })
    }
  end

  def goal_index
    goals = Goal.where(privacy: false)
    latest_goals = goals.limit(6)
    unachieved_goals = latest_goals.where(achieve_status: false)
    achieved_goals = latest_goals.where(achieve_status: true)
    render json: {
      goals: goals.as_json(methods: :image_url,
                           include: {
                             user: { methods: :image_url, only: %i[id name admin] }, goal_comments: { only: :id }
                           }),
      achieved_goals: achieved_goals.as_json(methods: :image_url,
                                             include: { user: { methods: :image_url, only: %i[id name admin] },
                                                        goal_comments: { only: :id } }),
      unachieved_goals: unachieved_goals.as_json(methods: :image_url,
                                                 include: { user: { methods: :image_url, only: %i[id name admin] },
                                                            goal_comments: { only: :id } })
    }
  end

  def community_index
    communities = Community.limit(6)
    render json: communities.as_json(except: %i[created_at updated_at], include: [{ users: { only: :id } }])
  end
end
