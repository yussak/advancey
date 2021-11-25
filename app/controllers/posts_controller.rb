class PostsController < ApplicationController
  before_action :logged_in_user, only: %i[create new edit update destroy]
  before_action :correct_user,   only: :destroy

  def create
    @post = current_user.posts.build(post_params)
    @post.image.attach(params[:post][:image])
    # if @post.save
    #   flash[:success] = '投稿を追加しました'
    #   # redirect_to root_url
    # else
    #   # render 'static_pages/home'するため
    #   # render 'static_pages/home'
    # end
    flash.now[:success] = '投稿を追加しました' if @post.save
    # 重すぎるので一時的に数制限(limit以下を消せば解除できる)
    @all_posts = current_user.feed.limit(5)
    @user_posts = current_user.posts.limit(5)
    @want_posts = current_user.posts.where(action: '実践したい').limit(5)
    @doing_posts = current_user.posts.where(action: '実践中').limit(5)
    @master_posts = current_user.posts.where(action: '身についた').limit(5)
    @like_posts = current_user.like_posts.limit(5)
  end

  def destroy
    # 重すぎるので一時的に数制限(limit以下を消せば解除できる)
    @all_posts = current_user.feed.limit(5)
    @user_posts = current_user.posts.limit(5)
    @want_posts = current_user.posts.where(action: '実践したい').limit(5)
    @doing_posts = current_user.posts.where(action: '実践中').limit(5)
    @master_posts = current_user.posts.where(action: '身についた').limit(5)
    @like_posts = current_user.like_posts.limit(5)

    @post.destroy
    flash.now[:success] = '投稿を削除しました'
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
      render :new
    end
  end

  def show
    @post = Post.find(params[:id])
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
