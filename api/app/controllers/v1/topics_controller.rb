class V1::TopicsController < ApplicationController
  def index
    # テキスト表示
    # render plain: 'test' # text:だとエラーになった
    # topics = Topic.all
    # render json: topics

    topic = Topic.all
    render json: topic
  end

  def create
    user = User.find_by(params[:user_id]) # postに合わせてfindにしたほうがいいかも
    topic = Topic.new(topic_params)
    topic.user_id = user.id
    if topic.save!
      render json: topic
    else
      render json: topic.errors
    end
  end

  private

  def topic_params
    params.require(:topic).permit(:title, :user_id) # 投稿のためにuser_id必要
  end
end
