require 'rails_helper'

RSpec.describe 'password resets', type: :system do
  before do
    ActionMailer::Base.deliveries.clear
  end
  let(:user) { FactoryBot.create(:user) }

  describe 'password resets' do
    it '' do
      get new_password_reset_path
      render_template 'password_resets/new'
      # assert_select 'input[name=?]', 'password_reset[email]'
    end

    # it 'パスワード空欄時' do
    #   post password_resets_path, params: { password_reset: { email: '' } }
    #   expect(flash).to be_truthy
    #   render_template 'password_resets/new'
    # end

    it 'パスワード有効時' do
      post password_resets_path,
           params: { password_reset: { email: user.email } }
      expect(user.reset_digest).not_to eq user.reload.reset_digest
      # assert_equal 1, ActionMailer::Base.deliveries.size
      expect(ActionMailer::Base.deliveries.size).to eq 1
      # assert_not flash.empty?
      # assert_redirected_to root_url
    end
  end

  it 'パスワード再設定フォームのテスト' do
    # user = assigns(:user)
  end

  it 'メールアドレスが無効' do
    # get edit_password_reset_path(user.reset_token, email: '')
    # assert_redirected_to root_url
  end

  it '無効なユーザー' do
    # user.toggle!(:activated)
    # get edit_password_reset_path(user.reset_token, email: user.email)
    # assert_redirected_to root_url
    # user.toggle!(:activated)
  end

  it 'メールアドレスが有効で、トークンが無効' do
    # get edit_password_reset_path('wrong token', email: user.email)
    # assert_redirected_to root_url
  end

  it 'メールアドレスもトークンも有効' do
    # get edit_password_reset_path(user.reset_token, email: user.email)
    # render_template 'password_resets/edit'
    # assert_select 'input[name=email][type=hidden][value=?]', user.email
  end

  it '無効なパスワードとパスワード確認' do
    # patch password_reset_path(user.reset_token),
    #       params: { email: user.email,
    #                 user: { password: 'foobaz',
    #                         password_confirmation: 'barquux' } }
    # assert_select 'div#error_explanation'
  end

  it 'パスワードが空' do
    # patch password_reset_path(user.reset_token),
    #       params: { email: user.email,
    #                 user: { password: '',
    #                         password_confirmation: '' } }
    # assert_select 'div#error_explanation'
  end

  it '有効なパスワードとパスワード確認' do
    # patch password_reset_path(user.reset_token),
    #       params: { email: user.email,
    #                 user: { password: 'foobaz',
    #                         password_confirmation: 'foobaz' } }
    # assert is_logged_in?
    # assert_not flash.empty?
    # assert_redirected_to user
  end
end
