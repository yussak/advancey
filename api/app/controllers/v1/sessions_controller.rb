class V1::SessionsController < ApplicationController
  def new
    user = User.new
    render json: user
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      log_in user
      # params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      # flash[:success] = 'ログインしました'
      # redirect_back_or root_url
      render json: user
    else
      # flash.now[:danger] = 'メールアドレスまたはパスワードが間違っています'
      # render 'new'
      render json: user.errors
    end
    user = User.new
    render json: user
  end

  # # def destroy
  # #   log_out if logged_in?
  # #   redirect_to root_url
  # # end
end
