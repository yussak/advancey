class UserMailer < ApplicationMailer
  default from: 'yusuke.sakuraba0213@gmail.com'

  def welcome_email
    @user = params[:user]
    @url  = 'http://example.com/login'
    mail(to: @user.email, subject: 'Bookwormへようこそ！！！')
  end
end
