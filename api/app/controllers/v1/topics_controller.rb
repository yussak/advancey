class V1::TopicsController < ApplicationController
  def index
    topics = Topic.all
    # render json: topics.as_json(methods: :image_url, except: [:updated_at],
    #                             include: { user: { only: [:name], methods: :image_url } })
    unsolved_topics = topics.where(solve_status: false)
    solved_topics = topics.where(solve_status: true)
    render json: { topics: topics.as_json(methods: :image_url, include: { user: { methods: :image_url, only: :name } }), solved_topics: solved_topics.as_json(methods: :image_url, include: { user: { methods: :image_url, only: :name } }),
                   unsolved_topics: unsolved_topics.as_json(methods: :image_url, include: { user: { methods: :image_url, only: :name } }) }
  end

  def create
    topic = Topic.new(topic_params)
    if topic.save
      render json: topic, methods: [:image_url]
    else
      render json: topic.errors
    end
  end

  def destroy
    topic = Topic.find(params[:id])
    render json: topic if topic.destroy
  end

  def show
    topic = Topic.find(params[:id])
    render json: topic.to_json(except: [:updated_at], methods: [:image_url],
                               include: [{ user: { methods: :image_url, only: :name } }, { topic_comments: { methods: :image_url, except: :updated_at, include: { user: { methods: :image_url, only: :name } } } }])
  end

  def update
    topic = Topic.find(params[:id])
    if topic.update(topic_params)
      render json: topic
    else
      render json: topic.errors
    end
  end

  private

  def topic_params
    params.require(:topic).permit(:user_id, :title, :content, :solve_status, :image)
  end
end
