class V1::PostsController < ApplicationController
  def index
    posts = Post.all
    render json: posts.to_json(methods: :image_url, except: %i[url updated_at],
                               include: { user: { only: [:name], methods: :image_url } })
  end

  def create
    post = Post.new(post_params)
    if post.save
      render json: post, methods: :image_url
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
    render json: post.to_json(methods: [:image_url],
                              include: [{ user: { methods: :image_url, only: :name } },
                                        { post_comments: { except: :updated_at,
                                                           methods: :image_url, include: { user: { only: :name, methods: :image_url } } } }])
  end

  def update
    post = Post.find(params[:id])
    if post.update(post_params)
      render json: post
    else
      render json: post.errors
    end
  end

  private

  def post_params
    params.require(:post).permit(:user_id, :content, :tag, :privacy, :image)
  end
end
