class V1::CommentsController < ApplicationController
  def create
    # find find_by揃えるとエラーになる
    user = User.find_by(params[:user_id]) # findだとエラーでた
    # user = User.find(params[:user_id])
    post = Post.find(params[:post_id]) # find_byだとコメントしてもpost#showに追加されなかった
    comment = Comment.new(comment_params)
    # ここいらないかも（なんとなく）
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
    render json: comment if comment.destroy
  end

  def update
    comment = Comment.find(params[:id])
    if comment.update(comment_params)
      render json: comment, methods: [:image_url]
    else
      render json: comment.errors
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:comment_content, :post_id, :user_id, :image)
  end
end
