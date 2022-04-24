require 'rails_helper'

RSpec.describe "Api::V1::News", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/api/v1/news/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/api/v1/news/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /destroy" do
    it "returns http success" do
      get "/api/v1/news/destroy"
      expect(response).to have_http_status(:success)
    end
  end

end
