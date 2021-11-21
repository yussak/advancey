class CommentsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @comment = current_user.comments.new(comment_params)
    @comment.post_id = @post.id
    if @comment.save
      flash.now[:success] = 'コメントを追加しました'
      render :index
    else
      render :error
    end
  end

  def destroy
    @comment = Comment.find_by(id: params[:id], post_id: params[:post_id])
    @comment.destroy
    flash.now[:success] = 'コメントを削除しました'
    @post = Post.find(params[:post_id])
    render :index
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :post_id)  # formでpost_idパラメータを送信して、コメントへpost_idを格納する
  end
end
