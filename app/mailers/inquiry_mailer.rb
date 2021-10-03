class InquiryMailer < ApplicationMailer
  def send_mail(inquiry)
    @inquiry = inquiry
    mail(
      from: 'yusuke.sakuraba0213@gmail.com',
      to: 'manager@example.com',
      subject: 'お問い合わせ通知'
    )
  end
end
