class CommentsController < ApplicationController
  # def create
  #   @post = Post.find(params[:post_id])
  #   @comment = current_user.comments.new(comment_params)
  #   @comment.post_id = @post.id
  #   flash.now[:success] = 'コメントを追加しました' if @comment.save
  # end

  # def destroy
  #   @comment = Comment.find(params[:id])
  #   @comment.destroy
  #   flash.now[:success] = 'コメントを削除しました'
  #   @post = Post.find(params[:post_id])
  # end

  def create
    @topic = Topic.find(params[:topic_id])
    @comment = current_user.comments.new(comment_params)
    # binding.pry
    if @comment.save!
      flash[:success] = 'コメント成功'
      redirect_to topic_path(@topic)
    else
      flash[:danger] = 'コメント失敗'
      redirect_to topic_path(@topic)
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:comment_content, :topic_id)
  end
end
