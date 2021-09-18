require 'rails_helper'

RSpec.describe "User login", type: :request do
    it 'can access login page' do
        get login_path
        expect(response).to have_http_status(200)
    end

    it 'login with invalid information' do
        get login_path
        expect(response).to have_http_status(200)

        post login_path, params: { session: { email: "", password: "" } }
        expect(response).to have_http_status(200)

        expect(flash[:danger]).to be_truthy

        get root_path
        expect(flash[:danger]).to be_falsey
    end
end