class V1::GoalsController < ApplicationController
  def index
    goals = Goal.all
    render json: goals.to_json(except: [:updated_at])
    # contentだけにするかも
  end

  def create
    goal = Goal.new(goal_params)
    if goal.save
      render json: goal
    else
      render json: goal.errors
    end
  end

  def destroy
    goal = Goal.find(params[:id])
    render json: goal if goal.destroy
  end

  def show
    goal = Goal.find(params[:id])
    render json: goal
  end

  private

  def goal_params
    params.require(:goal).permit(:user_id, :content, :reason, :todo, :period)
  end
end
