class V1::TopicCommentsController < ApplicationController
  def create
    topic_comment = TopicComment.new(topic_comment_params)
    if topic_comment.save!
      render json: topic_comment
    else
      render json: topic_comment.errors
    end
  end

  def destroy
    topic_comment = TopicComment.find(params[:id])
    render json: topic_comment if topic_comment.destroy
  end

  private

  def topic_comment_params
    params.require(:topic_comment).permit(:user_id, :topic_id, :content, :image)
  end
end
