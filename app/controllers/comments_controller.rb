class CommentsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @comment = current_user.comments.new(comment_params)
    @comment.post_id = @post.id
    flash.now[:success] = 'コメントを追加しました' if @comment.save
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    flash.now[:success] = 'コメントを削除しました'
    @post = Post.find(params[:post_id])
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :post_id)
  end
end
