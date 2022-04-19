class V1::TopicCommentsController < ApplicationController
  def create
    topic = Topic.find(params[:topic_id])
    topic_comment = TopicComment.new(topic_comment_params)
    if topic_comment.save!
      render json: topic
    else
      render json: topic.errors
    end
  end

  def destroy
    topic_comment = TopicComment.find(params[:id])
    render json: topic_comment if topic_comment.destroy
  end

  private

  def topic_comment_params
    params.require(:topic_comment).permit(:topic_comment_content, :topic_id, :user_id, :image)
  end
end
