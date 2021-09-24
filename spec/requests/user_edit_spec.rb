require 'rails_helper'

RSpec.describe 'User edit', type: :request do
  before do
    @user = FactoryBot.create(:user)
  end

  it 'ユーザー情報編集に失敗する' do
    get edit_user_path(@user)
    # assert_template 'users/edit'
    expect(response).to render_template('users/edit')
    patch user_path(@user), params: { user: { name: '',
                                              email: 'foo@invalid',
                                              password: 'foo',
                                              password_confirmation: 'bar' } }

    expect(response).to render_template('users/edit')
  end
end
