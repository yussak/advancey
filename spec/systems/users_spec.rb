require 'rails_helper'

RSpec.describe 'users', type: :system do
  describe 'user create a new account' do
    context '登録失敗時のエラーメッセージ' do
      before do
        visit signup_path
        fill_in 'user[name]', with: ''
        fill_in 'user[email]', with: ''
        fill_in 'user[password]', with: ''
        fill_in 'user[password_confirmation]', with: ''
        click_button '新規登録'
      end
      subject { page }
      it '登録失敗時のメッセージ' do
        is_expected.to have_selector('#error_explanation')
        is_expected.to have_selector('.alert-danger', text: 'The form contains 6 errors.')
        is_expected.to have_content("Password can't be blank", count: 2)
      end
      #今いるページのURLの検証
      it 'render to /signup url' do
        is_expected.to have_current_path '/users'
      end
    end

    context '登録成功時のメッセージ' do
        before do
            visit signup_path
            fill_in 'user[name]', with: 'user'
            fill_in 'user[email]', with: 'user@example.com'
            fill_in 'user[password]', with: 'password'
            fill_in 'user[password_confirmation]', with: 'password'
            click_button '新規登録'
        end
        it '成功時メッセージが出る' do
            expect(page).to have_selector('.alert-success', text: 'Bookwormへようこそ！')
        end
    end
  end
end