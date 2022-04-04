class V1::GoalCommentsController < ApplicationController
  # カレンダーに追加するため必要
  def index
    a = GoalComment.all
    render json: a.to_json(except: %i[created_at updated_at])
  end

  def create
    goal = Goal.find(params[:goal_id])
    user = User.find_by(params[:user_id])
    goal_comment = GoalComment.new(goal_comment_params)
    goal_comment.goal_id = goal.id
    goal_comment.user_id = user.id
    if goal_comment.save!
      render json: goal
    else
      render json: goal.errors
    end
  end

  def destroy
    goal_comment = GoalComment.find(params[:id])
    render json: goal_comment if goal_comment.destroy
  end

  private

  def goal_comment_params
    params.require(:goal_comment).permit(:user_id, :goal_id, :content, :comment_date)
  end
end
