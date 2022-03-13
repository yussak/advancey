class V1::TopicCommentsController < ApplicationController
  def index
    topic_comments = TopicComment.all
    # render json: topic_comments
    render json: topic_comments.to_json(methods: [:image_url]) # だとserializerが読まれず→username表示できない
  end

  def create
    topic = Topic.find(params[:topic_id])
    user = User.find_by(params[:user_id])
    topic_comment = TopicComment.new(topic_comment_params)
    topic_comment.topic_id = topic.id
    topic_comment.user_id = user.id
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
