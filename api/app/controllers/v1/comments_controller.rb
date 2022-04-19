class V1::CommentsController < ApplicationController
  def create
    comment = Comment.new(comment_params)
    if comment.save!
      render json: comment
    else
      render json: comment.errors
    end
  end

  def destroy
    comment = Comment.find(params[:id])
    render json: comment if comment.destroy
  end

  def update
    comment = Comment.find(params[:id])
    if comment.update(comment_params)
      render json: comment, methods: [:image_url]
    else
      render json: comment.errors
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:comment_content, :post_id, :user_id, :image)
  end
end
