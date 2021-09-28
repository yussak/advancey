require 'rails_helper'

RSpec.describe 'User edit', type: :request do
  context '編集をテスト' do
    before do
      @user = FactoryBot.create(:user)
    end

    it 'ユーザー情報編集に失敗する' do
      log_in_as(@user)
      get edit_user_path(@user)
      expect(response).to render_template('users/edit')
      patch user_path(@user), params: { user: { name: '',
                                                email: 'foo@invalid',
                                                password: 'foo',
                                                password_confirmation: 'bar' } }
      expect(response).to render_template('users/edit')
    end

    it 'ユーザー情報編集に成功する' do
      log_in_as(@user)
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

  context 'ログインしていない時にリダイレクトさせる' do
    before do
      @user = FactoryBot.create(:user)
    end
    it 'should redirect edit when not logged in' do
      get edit_user_path(@user)
      expect(flash[:danger]).to be_truthy
      expect(response).to redirect_to login_path
    end

    it 'should redirect update when not logged in' do
      patch user_path(@user), params: { user: { name: @user.name,
                                                email: @user.email } }
      expect(flash[:danger]).to be_truthy
      expect(response).to redirect_to login_path
    end
  end

  context '正しいユーザーを要求する' do
    before do
      @user = FactoryBot.create(:user)
      @other_user = FactoryBot.create(:user)
    end

    it 'should redirect edit when logged in as wrong user' do
      log_in_as(@other_user)
      get edit_user_path(@user)
      expect(flash[:danger]).to be_falsey
      expect(response).to redirect_to root_path
    end

    it 'should redirect update when logged in as wrong user' do
      log_in_as(@other_user)
      patch user_path(@user), params: { user: { name: @user.name,
                                                email: @user.email } }
      expect(flash[:danger]).to be_falsey
      expect(response).to redirect_to root_path
    end

    it 'should redirect index when not logged in' do
      get users_path
      expect(response).to redirect_to login_path
    end
  end

  context 'friendly fowrardling' do
    before do
      @user = FactoryBot.create(:user)
    end

    it 'successful edit with friendly forwarding' do
      get edit_user_path(@user)
      log_in_as(@user)
      expect(response).to redirect_to edit_user_url(@user)
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
end
