class InquiryMailer < ApplicationMailer
  def send_mail(inquiry)
    @inquiry = inquiry
    # mail(
    #   from: 'system@example.com',
    #   to: 'yusuke.sakuraba0213@gmail.com',
    #   subject: 'お問い合わせ通知'
    # )
    mail to:   ENV['TOMAIL'], subject: '【お問い合わせ】' + @contact.subject_i18n
  end
end
