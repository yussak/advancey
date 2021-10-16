class UserMailer < ApplicationMailer
  def password_reset
    @greeting = 'Hi'

    mail to: 'to@example.org'
  end
end
