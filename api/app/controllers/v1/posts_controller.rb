class V1::PostsController < ApplicationController
  def index
    posts = Post.all
    render json: posts.to_json(except: %i[url created_at updated_at])
  end

  def create
    post = Post.new(post_params)
    if post.save
      render json: post
    else
      render json: post.errors
    end
  end

  def destroy
    post = Post.find(params[:id])
    render json: post if post.destroy
  end

  def show
    post = Post.find(params[:id])
    render json: post.to_json(only: :content, include: [:comments])
    # render json: { post: post.as_json(only: :content, include: [:comments]) } だとフロントに値が渡らなかった
  end

  def edit
    post = Post.find(params[:id])
    render json: post
  end

  def update
    post = Post.find(params[:id])
    if post.update(post_params)
      render json: post
    else
      render json: post.errors
    end
  end

  def private_index
    # 他の人の投稿も見えてしまうので要修正
    private_posts = Post.where(privacy: true)
    render json: private_posts
  end

  private

  def post_params
    params.require(:post).permit(:user_id, :content, :tag, :privacy) # 投稿のためにuser_id必要
  end
end
