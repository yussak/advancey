class GuestSessionsController < ApplicationController
  def create
    user = User.find_or_create_by(email: 'guest@exapmle.com') do |u|
      u.password = SecureRandom.urlsafe_base64
      u.name = 'ゲストユーザー'
    end
    log_in(user)
    flash[:success] = 'ゲストユーザーとしてログインしました'
    redirect_to user
  end
end
