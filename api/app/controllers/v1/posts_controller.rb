class V1::PostsController < ApplicationController
  # なくても表示できてる気がする
  # def index
  #   posts = Post.all
  #   render json: posts.to_json(methods: [:image_url], include: { user: { only: :name } },
  #                              except: %i[url created_at updated_at])
  # end

  def create
    post = Post.new(post_params)
    if post.save
      render json: post, methods: [:image_url]
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
                              include: [{ user: { only: :name } },
                                        { comments: { except: :updated_at,
                                                      methods: :image_url, include: { user: { only: :name } } } }])
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
    private_posts = Post.where(privacy: true)
    render json: private_posts
  end

  private

  def post_params
    params.require(:post).permit(:user_id, :content, :tag, :privacy, :image) # 投稿のためにuser_id必要
  end
end
