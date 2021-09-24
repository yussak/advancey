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

  it 'ユーザー情報編集に成功する' do
    get edit_user_path(@user)
    expect(response).to render_template('users/edit')
    name  = 'Foo Bar'
    email = 'foo@bar.com'
    patch user_path(@user), params: { user: { name: name,
                                              email: email,
                                              password: '',
                                              password_confirmation: '' } }
    expect(flash[:success]).to be_truthy
    expect(response).to redirect_to @user
    @user.reload
    expect(name).to eq @user.name
    expect(email).to eq @user.email
  end
end
