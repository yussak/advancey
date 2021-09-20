require 'rails_helper'

RSpec.describe 'User login', type: :request do
  before do
    get login_path
    expect(response).to have_http_status(200)
  end

  context 'ログイン失敗時' do
    it 'ログインに失敗してflash messageが出る' do
      post login_path, params: { session: { email: '', password: '' } }
      expect(response).to have_http_status(200)
      expect(flash[:danger]).to be_truthy
    end
    it '他ページに移動するとメッセージが消える' do
      get root_path
      expect(flash[:danger]).to be_falsey
    end
  end

  context 'ログイン成功時' do
    before do
      @user = FactoryBot.create(:user)
    end
    it 'login with valid information' do
      post login_path, params: { session: { email: @user.email, password: @user.password } }
      expect(response).to redirect_to @user
      follow_redirect!
      expect(response).to render_template('users/show')
    end

    it 'login with valid email & invalid password' do
      post login_path, params: { session: { email: @user.email, password: 'invalid' } }
      expect(is_logged_in?).to be_falsey
      expect(flash[:danger]).to be_truthy
      get root_path
      expect(flash[:danger]).to be_falsey
    end
  end
end
