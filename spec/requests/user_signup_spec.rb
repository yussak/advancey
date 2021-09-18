require 'rails_helper'

RSpec.describe "User Signup", type: :request do
  context "ユーザー登録失敗時" do
    let(:user_params) do
      attributes_for(:user, name: '',
                            email: 'user@invalid',
                            password: 'foo',
                            password_confirmation: 'bar')
    end
  
    before do
      get signup_path
    end
  
    it "does not add a user" do
      expect do
        post users_path, params: { user: user_params }
      end.to change(User, :count).by(0)
      expect(response).to render_template('users/new')
    end
  end

  context "ユーザー登録成功時" do
    let(:user_params) do
      attributes_for(:user, name: 'user',
                            email: 'user@example.com',
                            password: 'password',
                            password_confirmation: 'password')
    end

    before do
      get signup_path
    end
  
    it "add a user" do
      expect do
        post users_path, params: { user: user_params }
      end.to change(User, :count).by(1)
      follow_redirect!
      expect(response).to render_template('users/show')
    end
  end
end
