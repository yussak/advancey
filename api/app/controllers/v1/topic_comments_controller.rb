class V1::TopicCommentsController < ApplicationController
  def index
    topic_comments = TopicComment.all
    render json: topic_comments
  end

  def create
    # topic = Topic.find_by(params[:topic_id])
    topic = Topic.find(params[:topic_id])
    user = User.find_by(params[:user_id]) # findだとエラーでた
    topic_comment = TopicComment.new(topic_comment_params)
    topic_comment.topic_id = topic.id
    topic_comment.user_id = user.id
    if topic_comment.save!
      render json: topic
    else
      render json: topic.errors
    end
  end

  # def destroy
  #   topic = Topic.find(params[:topic_id])
  #   topic_comment = TopicComment.find(params[:id])
  #   if topic_comment.destroy
  #     flash[:success] = '質問を削除しました'
  #     redirect_to topic_path(topic)
  #   end
  # end

  private

  def topic_comment_params
    params.require(:topic_comment).permit(:topic_comment_content, :topic_id, :user_id)
    # params.require(:topic_comment).permit(:topic_comment_content, :topic_id)
  end
end
