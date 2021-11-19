class CommentsController < ApplicationController
  def create
    @comment = current_user.comments.new(comment_params)
    @comment.post_id = params[:post_id]
    if @comment.save
      flash[:success] = 'コメントを追加しました'
      redirect_back(fallback_location: root_path)
    else
      @post = Post.find(params[:post_id])
      @comments = @post.comments
      render 'posts/show'
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    if @comment.destroy
      flash[:success] = 'コメントを削除しました'
      redirect_back(fallback_location: root_path)
    else
      flash.now[:danger] = 'コメント削除に失敗しました'
      # ↓多分使えない
      render post_path(@post)
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :post_id)  # formでpost_idパラメータを送信して、コメントへpost_idを格納する
  end
end
