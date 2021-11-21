class CommentsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])

    @comment = current_user.comments.new(comment_params)
    # @comment.post_id = params[:post_id]
    @comment.post_id = @post.id

    if @comment.save
      flash.now[:success] = 'コメントを追加しました'
      render :index

    # redirect_to post_path(@post)
    # flash[:success] = 'コメントを追加しました'
    # redirect_back(fallback_location: root_path)
    # respond_to do |format|
    #   # format.html { redirect_to post_path }
    #   format.html
    #   format.js
    # end
    else
      # @post = Post.find(params[:post_id])
      # @comments = @post.comments
      # render 'posts/show'
      render :error
    end
  end

  def destroy
    # @comment = Comment.find(params[:id])
    @comment = Comment.find_by(id: params[:id], post_id: params[:post_id])
    @comment.destroy
    flash.now[:danger] = '投稿を削除しました'
    @post = Post.find(params[:post_id])
    render :index # render先にjsファイルを指定

    # if @comment.destroy
    # flash[:success] = 'コメントを削除しました'
    # redirect_back(fallback_location: root_path)
    # respond_to do |format|
    #   # format.html { redirect_to post_path }
    #   format.html
    #   format.js
    # end
    # else
    #   flash.now[:danger] = 'コメント削除に失敗しました'
    #   # ↓多分使えない
    #   # render post_path(@post)
    # end
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :post_id)  # formでpost_idパラメータを送信して、コメントへpost_idを格納する
  end
end
