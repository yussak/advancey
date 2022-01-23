class TopicsController < ApplicationController
  before_action :logged_in_user, only: %i[create new edit update destroy]
  before_action :correct_user,   only: :destroy

  def new
    @topic = Topic.new
  end

  def create
    @topic = current_user.topics.build(topic_params)
    # @topic = Topic.new(params[:topic].permit(:title))
    if @topic.save
      flash[:success] = '質問を追加しました'
      redirect_to topics_path
    end
  end

  def index
    @topics = current_user.topics.all
    # @newTopic = Topic.new
  end

  private

  def topic_params
    # params.require(:topic).permit(:title, :content)
    params.permit(:title, :content)
  end
end
