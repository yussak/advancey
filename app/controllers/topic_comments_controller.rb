class TopicCommentsController < ApplicationController
  def create
    @topic = Topic.find(params[:topic_id])
    @topic_comment = current_user.topic_comments.new(topic_comment_params)
    if @topic_comment.save
      flash[:success] = 'コメント成功'
      redirect_to topic_path(@topic)
    else
      flash[:danger] = 'コメント失敗'
      redirect_to topic_path(@topic)
    end
  end

  private

  def topic_comment_params
    params.require(:topic_comment).permit(:topic_comment_content, :topic_id)
  end
end
