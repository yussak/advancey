class TopicsController < ApplicationController
  before_action :logged_in_user, only: %i[create new edit update destroy]
  before_action :correct_user,   only: :destroy

  def index
    @user = User.new
    @topics = Topic.all
    # @topics = current_user.topics.all
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

  def destroy
    @topic = Topic.find(params[:id])
    if @topic.destroy
      flash[:success] = '質問を削除しました'
      redirect_to topics_path
    end
  end

  def show
    @topic = Topic.find(params[:id])
    @topic_comments = @topic.topic_comments
    @topic_comment = current_user.topic_comments.new # 詳細画面で追加するため
  end

  private

  def topic_params
    params.permit(:title, :content)
  end

  def correct_user
    @topic = current_user.topics.find_by(id: params[:id])
    redirect_to root_url if @topic.nil?
  end
end