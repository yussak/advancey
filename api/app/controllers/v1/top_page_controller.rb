class V1::TopPageController < ApplicationController
  # 全体的にas_jsonで絞る
  def post_index
    public_posts = Post.where(privacy: false)
    latest_posts = public_posts.limit(6)
    doing_posts = latest_posts.where(tag: '実践中')
    want_posts = latest_posts.where(tag: '実践したい')
    master_posts = latest_posts.where(tag: '身についた')
    render json: {
      posts: latest_posts.as_json(methods: :image_url, except: [:updated_at],
                                  include: { user: { methods: :image_url,
                                                     only: :name } }), doing_posts: doing_posts.as_json(methods: :image_url, include: { user: { methods: :image_url, only: :name } }), want_posts: want_posts.as_json(methods: :image_url, include: { user: { methods: :image_url, only: :name } }), master_posts: master_posts.as_json(methods: :image_url, include: { user: { methods: :image_url, only: :name } })
    }
  end

  def topic_index
    # default scope無いので要追加
    topics = Topic.limit(6)
    unsolved_topics = topics.where(solve_status: false)
    solved_topics = topics.where(solve_status: true)
    render json: { topics: topics.as_json(methods: :image_url, include: { user: { methods: :image_url, only: :name } }), solved_topics: solved_topics.as_json(methods: :image_url, include: { user: { methods: :image_url, only: :name } }),
                   unsolved_topics: unsolved_topics.as_json(methods: :image_url, include: { user: { methods: :image_url, only: :name } }) }
  end

  def goal_index
    # default scopeなければ追加
    # falseじゃなくnullになるので要修正
    goals = Goal.limit(6)
    unachieved_goals = goals.where(achieve_status: false)
    achieved_goals = goals.where(achieve_status: true)
    render json: { goals: goals, achieved_goals: achieved_goals, unachieved_goals: unachieved_goals }
  end

  def community_index
    # default scopeないので追加
    communities = Community.limit(6)
    render json: communities.as_json(except: %i[created_at updated_at], include: [{ users: { only: [:id] } }])
  end
end
