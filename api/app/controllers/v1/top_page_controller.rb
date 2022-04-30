class V1::TopPageController < ApplicationController
  def post_index
    public_posts = Post.where(privacy: false)
    latest_posts = public_posts.limit(6)
    doing_posts = latest_posts.where(tag: '実践中')
    want_posts = latest_posts.where(tag: '実践したい')
    master_posts = latest_posts.where(tag: '身についた')
    render json: { doing_posts: doing_posts.as_json(include: { user: { methods: :image_url, only: :name } }), want_posts: want_posts.as_json(include: { user: { methods: :image_url, only: :name } }), master_posts: master_posts.as_json(include: { user: { methods: :image_url, only: :name } }),
                   posts: latest_posts.as_json(except: [:updated_at], include: { user: { methods: [:image_url], only: :name } }) }
  end

  def topic_index
    # topic default scope無いので要追加
    topics = Topic.limit(6)
    unsolved_topics = topics.where(solve_status: false)
    solved_topics = topics.where(solve_status: true)
    render json: { topics: topics, solved_topics: solved_topics, unsolved_topics: unsolved_topics }
  end

  def goal_index
    # a
  end

  def community_index
    # a
  end
end
