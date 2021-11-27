class UsersController < ApplicationController
  before_action :logged_in_user, only: %i[index edit update destroy following followers]
  before_action :correct_user,   only: %i[edit update]

  def index
    @users = User.page(params[:page]).per(10)
  end

  def show
    @user = User.find(params[:id])
    # 重すぎるので一時的に数制限(limit以下を消せば解除できる)
    # @user_posts = @user.posts.limit(10)
    # @want_posts = @user.posts.where(action: '実践したい').limit(10)
    # @doing_posts = @user.posts.where(action: '実践中').limit(10)
    # @master_posts = @user.posts.where(action: '身についた').limit(10)
    # # @like_posts = @user.like_posts.limit(10)
    # # いいねをつけた順に表示
    # @like_posts = @user.likes.order(created_at: 'DESC').limit(10).map { |like| like.post }

    @user_posts = @user.posts.page(params[:page]).without_count.per(5)
    @want_posts = @user.posts.where(action: '実践したい').page(params[:page]).without_count.per(5)
    @doing_posts = @user.posts.where(action: '実践中').page(params[:page]).without_count.per(5)
    @master_posts = @user.posts.where(action: '身についた').page(params[:page]).without_count.per(5)
    # いいねをつけた順に表示
    # @like_posts = @user.likes.order(created_at: 'DESC').map { |like| like.post }
    # ↓なんかエラー出るので一時的に並び替え解除
    @like_posts = @user.like_posts.page(params[:page]).without_count.per(5)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = 'Bookwormへようこそ！'
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    # ゲストユーザーでは編集できないようにする
    if @user.email == 'guest@exapmle.com'
      flash[:danger] = 'ゲストユーザーは編集できません'
      render 'edit'
    elsif @user.update(user_params)
      flash[:success] = '更新完了しました'
      redirect_to @user
    else
      render 'edit'
    end
  end

  def following
    @title = 'フォロー中'
    @user  = User.find(params[:id])
    @users = @user.following.page(params[:page]).per(5)
    render 'show_follow'
  end

  def followers
    @title = 'フォロワー'
    @user  = User.find(params[:id])
    @users = @user.followers.page(params[:page]).per(5)
    render 'show_follow'
  end

  def destroy
    @user = User.find(params[:id])
    # ゲストユーザーでは退会できないようにする
    if @user.email == 'guest@exapmle.com'
      flash[:danger] = 'ゲストユーザーは退会できません'
      render 'edit'
    else
      @user.destroy
      reset_session
      flash[:success] = 'ユーザーを削除しました'
      redirect_to root_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :profile)
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end
end
