require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  let(:user) { FactoryBot.create(:user) }

  it 'パスワードリセット' do
    user.reset_token = User.new_token
    mail = UserMailer.password_reset(user)
    expect(mail.subject).to eq 'パスワード再発行'
    expect(mail.to).to eq [user.email]
    expect(mail.from).to eq ['yusuke.sakuraba0213@gmail.com']
    expect(mail.html_part.body.to_s).to match user.reset_token
    expect(mail.html_part.body.to_s).to match CGI.escape(user.email)
  end
end
