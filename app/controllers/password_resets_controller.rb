class PasswordResetsController < ApplicationController
  before_action :get_user,   only: %i[edit update]
  before_action :valid_user, only: %i[edit update]

  def new; end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = '再発行リンク付きメール送信完了しました'
      redirect_to root_url
    else
      flash.now[:danger] = 'アドレスが見つかリません'
      render 'new'
    end
  end

  def edit; end

  private

  def get_user
    @user = User.find_by(email: params[:email])
  end

  def valid_user
    # ユーザー認証実装するまでこちらで進める
    redirect_to root_url unless @user && @user.authenticated?(:reset, params[:id])

    # ユーザー認証実装したらコメント解除
    # unless @user && @user.activated? &&
    #        @user.authenticated?(:reset, params[:id])
    #   redirect_to root_url
    # end
  end
end
