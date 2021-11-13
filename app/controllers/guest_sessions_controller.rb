class GuestSessionsController < ApplicationController
  def create
    user = User.guest
    log_in(user)
    flash[:success] = 'ゲストユーザーとしてログインしました'
    redirect_to user
  end
end
