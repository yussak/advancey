class V1::GoalCommentsController < ApplicationController
  def create
    comment = GoalComment.new(comment_params)
    if comment.save!
      render json: comment
    else
      render json: comment.errors
    end
  end

  def destroy
    comment = GoalComment.find(params[:id])
    render json: comment if comment.destroy
  end

  def update
    comment = GoalComment.find(params[:id])
    if comment.update(comment_params)
      render json: comment
    else
      render json: comment.errors
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:user_id, :goal_id, :content, :comment_date)
  end
end
