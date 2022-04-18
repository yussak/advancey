class V1::GoalsController < ApplicationController
  # user controllerで読み込んでこっちは廃止するかも
  # そのほうがuserのgoalというふうに取得できるので良い
  def index
    goals = Goal.all
    user = User.find_by(params[:user_id])
    render json: user.goals
    # render json: goals.to_json(except: [:updated_at], include: [{ user: { only: :name } }])
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

  private

  def goal_params
    params.require(:goal).permit(:user_id, :content, :reason, :todo, :image)
  end
end
