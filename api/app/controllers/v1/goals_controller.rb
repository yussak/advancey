class V1::GoalsController < ApplicationController
  def index
    goals = Goal.all
    unachieved_goals = goals.where(achieve_status: false)
    achieved_goals = goals.where(achieve_status: true)
    render json: { goals: goals.as_json(methods: :image_url, include: { user: { methods: :image_url, only: :name } }),
                   achieved_goals: achieved_goals.as_json(methods: :image_url, include: { user: { methods: :image_url, only: :name } }), unachieved_goals: unachieved_goals.as_json(methods: :image_url, include: { user: { methods: :image_url, only: :name } }) }
  end

  def create
    goal = Goal.new(goal_params)
    if goal.save
      render json: goal, methods: [:image_url]
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
    render json: goal.to_json(except: [:updated_at], methods: [:image_url],
                              include: [{ user: { only: :name } },
                                        { goal_comments: {
                                          except: %i[created_at updated_at goal_id], include: { user: { only: :name } }
                                        } }])
  end

  def update
    goal = Goal.find(params[:id])
    if goal.update(goal_params)
      render json: goal
    else
      render json: goal.errors
    end
  end

  private

  def goal_params
    params.require(:goal).permit(:user_id, :content, :reason, :todo, :achieve_status, :image)
  end
end
