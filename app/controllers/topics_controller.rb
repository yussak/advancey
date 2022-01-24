class TopicsController < ApplicationController
  before_action :logged_in_user, only: %i[create new edit update destroy]
  before_action :correct_user,   only: :destroy

  def index
    @topics = current_user.topics.all
  end

  def new
    @topic = Topic.new
  end

  def create
    @topic = current_user.topics.build(topic_params)
    if @topic.save
      flash[:success] = '質問を追加しました'
      redirect_to topics_path
    end
  end

  def show
    @topic = Topic.find(params[:id])
    @comments = @topic.comments
    @comment = current_user.comments.new # 詳細画面で追加するため
  end

  private

  def topic_params
    params.permit(:title, :content)
  end
end
