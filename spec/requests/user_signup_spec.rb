require 'rails_helper'

RSpec.describe "UserSignup", type: :request do
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
  end

end
