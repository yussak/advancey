require 'rails_helper'

RSpec.describe 'users', type: :system do
  describe 'user create a new account' do
    context 'enter an invalid values' do
      before do
        visit signup_path
        # fill_in 'name', with: ''
        fill_in 'user[name]', with: ''
        fill_in 'user[email]', with: ''
        fill_in 'user[password]', with: ''
        fill_in 'user[password_confirmation]', with: ''
        click_button '新規登録'
      end
      subject { page }
      #エラーの検証
      it 'get errors' do
        is_expected.to have_selector('#error_explanation')
        is_expected.to have_selector('.alert-danger', text: 'The form contains 6 errors.')
        is_expected.to have_content("Password can't be blank", count: 2)
      end
      #今いるページのURLの検証
      it 'render to /signup url' do
        is_expected.to have_current_path '/users'
      end
    end
  end
end