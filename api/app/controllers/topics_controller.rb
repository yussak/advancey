class TopicsController < ApplicationController
  before_action :logged_in_user, only: %i[create new edit update destroy]
  before_action :correct_user,   only: :destroy

  def index
    @topics = Topic.all
    @topic = Topic.new
  end

  def new
    @topic = Topic.new
  end

  def create
    @topic = current_user.topics.build(topic_params)
    if @topic.save
      flash[:success] = '質問を追加しました'
      redirect_to topics_path
    else
      @topics = Topic.all
      render :index
    end
  end

  def destroy
    @topic = Topic.find(params[:id])
    if @topic.destroy
      flash[:success] = '質問を削除しました'
      redirect_to topics_path
    end
  end

  def edit
    @topic = Topic.find(params[:id])
  end

  def update
    @topic = Topic.find(params[:id])
    if @topic.update(topic_params)
      flash[:success] = '質問を編集しました'
      redirect_to topic_path(@topic)
    else
      render :edit
    end
  end

  def show
    @topic = Topic.find(params[:id])
    @topic_comments = @topic.topic_comments
    @topic_comment = current_user.topic_comments.new
  end

  private

  def topic_params
    params.require(:topic).permit(:title, :content, :solve_status)
  end

  def correct_user
    @topic = current_user.topics.find_by(id: params[:id])
    redirect_to root_url if @topic.nil?
  end
end
