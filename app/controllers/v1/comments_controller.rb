class V1::CommentsController < ApplicationController
  def index
    comment = Comment.all
    render json: comment
  end

  def create
    user = User.find_by(params[:user_id]) # postに合わせてfindにしたほうがいいかも
    post = Post.find(params[:post_id]) # find_byだとコメントしてもpost#showに追加されなかった
    comment = Comment.new(comment_params)
    comment.post_id = post.id
    comment.user_id = user.id
    if comment.save!
      render json: comment
    else
      render json: comment.errors
    end
  end

  def destroy
    comment = Comment.find(params[:id])
    if comment.destroy
      post = Post.find(params[:post_id])
      render json: comment
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:comment_content, :post_id, :user_id)
    # params.require(:comment).permit(:comment_content, :post_id)
  end
end
