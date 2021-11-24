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
    #   @user_posts = current_user.posts.all
    #   @want_posts = current_user.posts.where(action: '実践したい')
    #   @doing_posts = current_user.posts.where(action: '実践中')
    #   @master_posts = current_user.posts.where(action: '身についた')
    #   @like_posts = current_user.like_posts
    #   # render 'static_pages/home' #ajaxのため消してみる

    # 重すぎるので一時的に数制限
    @all_posts = current_user.feed.limit(5)
    # end
    flash[:success] = '投稿を追加しました' if @post.save
  end

  def destroy
    @all_posts = current_user.feed.limit(5)

    @post.destroy
    flash[:success] = '投稿を削除しました'
    # redirect_to root_url
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
    @comment = current_user.comments.new # 投稿詳細画面でコメント追加するので、formのパラメータ用にCommentオブジェクトを取得
    # 若い順に並び替えたいが使えるかも↓
    @comments = @post.comments
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
