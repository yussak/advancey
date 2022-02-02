class V1::UsersController < ApplicationController
  before_action :logged_in_user, only: %i[edit update destroy following followers]
  before_action :correct_user,   only: %i[edit update]

  def index
    users = User.all
    render json: users
  end

  def show
    user = User.find(params[:id])
    user_posts = user.posts.where(privacy: false).page(params[:page]).per(9)
    want_posts = user.posts.where(privacy: false).where(tag: '実践したい').page(params[:page]).per(9)
    doing_posts = user.posts.where(privacy: false).where(tag: '実践中').page(params[:page]).per(9)
    master_posts = user.posts.where(privacy: false).where(tag: '身についた').page(params[:page]).per(9)
    like_posts = user.like_posts.where(privacy: false).page(params[:page]).per(9)

    render json: user
  end

  def new
    @user = User.new
  end

  def create
    user = User.new(user_params)
    if user.save
      log_in user
      render json: user
    else
      render json: user.errors
    end
  end

  def edit
    user = User.find(params[:id])
  end

  def update
    user = User.find(params[:id])
    if user.email == 'guest@exapmle.com'
      render json: user.errors
    elsif @user.update(user_params)
      render json: user
    else
      # render 'edit' #何でこういう分岐にしたんだっけ
      render json: user
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

  def search
    @users = User.where('name LIKE ?', "%#{params[:keyword]}%").page(params[:page]).per(10)
    @keyword = params[:keyword]
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
