class TopicCommentsController < ApplicationController
  def create
    @topic = Topic.find(params[:topic_id])
    @topic_comment = current_user.topic_comments.new(topic_comment_params)
    if @topic_comment.save
      flash[:success] = 'コメントを追加しました'
      redirect_to topic_path(@topic)
    else
      @topics = Topic.all
      redirect_to topic_path(@topic)
      flash[:danger] = @topic_comment.errors.full_messages[0] # renderだとURLが変わってしまいリロードでエラーになるのでここに書く。errors.full_messagesだけだと配列になるので[0]で中身を取り出す
    end
  end

  private

  def topic_comment_params
    params.require(:topic_comment).permit(:topic_comment_content, :topic_id)
  end
end
