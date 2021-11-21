class PostsController < ApplicationController
  before_action :logged_in_user, only: %i[create new edit update destroy]
  before_action :correct_user,   only: :destroy

  def create
    @post = current_user.posts.build(post_params)
    @post.image.attach(params[:post][:image])
    if @post.save
      flash[:success] = '投稿を追加しました'
      redirect_to root_url
    else
      # render 'static_pages/home'するため
      # page不要なら削除
      @feed_items = current_user.feed.page(params[:page])
      @user_posts = current_user.posts.page(params[:page])
      @like_posts = current_user.like_posts
      render 'static_pages/home'
    end
  end

  def destroy
    @post.destroy
    flash[:success] = '投稿を削除しました'
    redirect_to root_url
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to root_url
    else
      render :new
    end
  end

  def show
    @post = Post.find(params[:id])
    @comments = @post.comments.order(created_at: 'DESC')
    @comment = current_user.comments.new # 投稿詳細画面でコメント追加するので、formのパラメータ用にCommentオブジェクトを取得
  end

  private

  def post_params
    params.require(:post).permit(:content, :image, :action)
  end

  def correct_user
    @post = current_user.posts.find_by(id: params[:id])
    redirect_to root_url if @post.nil?
  end
end
