class V1::TopicsController < ApplicationController
  def index
    topics = Topic.all
    render json: topics
  end

  def create
    topic = Topic.new(topic_params)
    if topic.save
      render json: topic
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
    render json: topic
  end

  private

  def topic_params
    params.require(:topic).permit(:user_id, :title, :content, :solve_status) # 投稿のためにuser_id必要
  end
end
