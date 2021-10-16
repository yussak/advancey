require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  describe 'password_reset' do
    let(:user) { FactoryBot.create(:user) }
    it 'password_reset' do
      user.reset_token = User.new_token
      mail = UserMailer.password_reset(user)
      assert_equal 'Password reset', mail.subject
      assert_equal [user.email], mail.to
      assert_equal [''], mail.from
      assert_match user.reset_token,        mail.body.encoded
      assert_match CGI.escape(user.email),  mail.body.encoded
    end
  end
end
