class V1::TopicCommentsController < ApplicationController
  def create
    comment = TopicComment.new(comment_params)
    if comment.save!
      render json: comment
    else
      render json: comment.errors
    end
  end

  def destroy
    comment = TopicComment.find(params[:id])
    render json: comment if comment.destroy
  end

  def update
    comment = TopicComment.find(params[:id])
    if comment.update(comment_params)
      render json: comment, methods: [:image_url]
    else
      render json: comment.errors
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:user_id, :topic_id, :content, :image)
  end
end
