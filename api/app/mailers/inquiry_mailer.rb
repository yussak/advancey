class InquiryMailer < ApplicationMailer
  def send_mail(inquiry)
    @inquiry = inquiry
    mail to: ENV['MAIL_USERNAME'], subject: '【お問い合わせ】がありました'
  end

  def thanks_mail(inquiry)
    @inquiry = inquiry
    mail to: @inquiry.email, subject: '【お問い合わせ】を受け付けました'
  end
end
