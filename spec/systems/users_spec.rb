require 'rails_helper'

RSpec.describe 'users', type: :system do
  describe '新規登録' do
    context '登録失敗時' do
      before do
        visit signup_path
        fill_in 'user[name]', with: ''
        fill_in 'user[email]', with: ''
        fill_in 'user[password]', with: ''
        fill_in 'user[password_confirmation]', with: ''
        click_button '新規登録'
      end
      subject { page }
      it '登録失敗時のメッセージが出る' do
        is_expected.to have_selector('#error_explanation')
        is_expected.to have_selector('.alert-danger', text: 'The form contains 6 errors.')
        is_expected.to have_content("Password can't be blank", count: 2)
      end
      it 'render to /signup url' do
        is_expected.to have_current_path '/users'
      end
    end
    context '登録成功時' do
      before do
        visit signup_path
        fill_in 'user[name]', with: 'user'
        fill_in 'user[email]', with: 'user@example.com'
        fill_in 'user[password]', with: 'password'
        fill_in 'user[password_confirmation]', with: 'password'
        click_button '新規登録'
      end
      it '登録成功のメッセージが出る' do
        expect(page).to have_selector('.alert-success', text: 'Bookwormへようこそ！')
      end
    end
  end
  describe 'ログイン' do
    context 'ログイン成功時' do
      before do
        @user = FactoryBot.create(:user)
        visit login_path
        fill_in 'session[email]', with: @user.email
        fill_in 'session[password]', with: @user.password
        click_button 'ログイン'
      end
      it 'ログイン成功する' do
        expect(current_path).to eq user_path(@user)
        expect(page).not_to have_link 'ログイン', href: login_path
        expect(page).to have_link 'ログアウト', href: logout_path, visible: false
        expect(page).to have_link nil, href: user_path(@user), visible: false
      end

      it 'ログアウトしてリンクなくなる' do
        click_button 'Account'
        click_link 'ログアウト'
        delete logout_path
        expect(current_path).to eq root_path
        delete logout_path
        expect(page).to have_link 'ログイン', href: login_path
        expect(page).not_to have_link 'ログアウト', href: logout_path, visible: false
        expect(page).not_to have_link nil, href: user_path(@user), visible: false
      end
    end
  end
end
