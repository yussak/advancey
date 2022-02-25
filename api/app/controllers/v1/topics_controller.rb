class V1::TopicsController < ApplicationController
  def index
    topics = Topic.all
    render json: topics
  end

  def create
    user = User.find_by(params[:user_id])
    topic = Topic.new(topic_params)
    topic.user_id = user.id
    if topic.save
      # if topic.save!
      render json: topic
    else
      render json: topic.errors
    end
  end

  def destroy
    topic = Topic.find(params[:id])
    if topic.destroy
      render json: topic
    end
  end

  private

  def topic_params
    params.require(:topic).permit(:title, :user_id) # 投稿のためにuser_id必要
  end
end
