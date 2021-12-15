class PostsController < ApplicationController
  before_action :logged_in_user, only: %i[create new edit update destroy]
  before_action :correct_user,   only: :destroy

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    @post.image.attach(params[:post][:image])
    flash.now[:success] = '投稿を追加しました' if @post.save
    @all_posts = current_user.feed.page(params[:page]).per(3)
    @user_posts = current_user.posts.page(params[:page]).per(3)
    @want_posts = current_user.posts.where(action: '実践したい').page(params[:page]).per(3)
    @doing_posts = current_user.posts.where(action: '実践中').page(params[:page]).per(3)
    @master_posts = current_user.posts.where(action: '身についた').page(params[:page]).per(3)
    # # ↓なんかエラー出るので一時的に並び替え解除
    @like_posts = current_user.like_posts.page(params[:page]).per(3)

    # # # いいねをつけた順に表示
    # # @like_posts = current_user.likes.order(created_at: 'DESC').limit(10).map { |like| like.post }
  end

  def destroy
    flash.now[:success] = '投稿を削除しました' if @post.destroy
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      flash[:success] = '投稿を編集しました'
      redirect_to root_url
    else
      render :edit
    end
  end

  def show
    @post = Post.find(params[:id])
    @comment = current_user.comments.new
  end

  # def search
  #   if params[:keyword].present?
  #     @posts = Post.where('content LIKE ?', "%#{params[:keyword]}%")
  #     @keyword = params[:keyword]
  #     # else
  #     #   @posts = Post.all
  #   end
  # end

  def search
    if params[:hoge].present?
      @posts = Post.where('action LIKE ?', "%#{params[:hoge]}%")
      @keyword = params[:hoge]
    end
  end

  private

  def post_params
    params.require(:post).permit(:content, :image, :action, :url)
  end

  def correct_user
    @post = current_user.posts.find_by(id: params[:id])
    redirect_to root_url if @post.nil?
  end
end
