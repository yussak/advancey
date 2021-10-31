class UsersController < ApplicationController
  before_action :logged_in_user, only: %i[index edit update destroy following followers]
  before_action :correct_user,   only: %i[edit update]

  def index
    @users = User.page(params[:page]).per(5)
  end

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.page(params[:page]).per(5)
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
    if @user.update(user_params)
      flash[:success] = '更新完了！！！'
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
    User.find(params[:id]).destroy
    reset_session
    flash[:success] = 'ユーザーを削除しました'
    redirect_to root_path
  end

  def like_list
    @user = User.find(params[:id])
    @likes = @user.like_posts.page(params[:page]).per(5)
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end
end
