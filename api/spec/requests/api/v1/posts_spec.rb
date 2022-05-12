require 'rails_helper'

RSpec.describe 'Api::V1::Posts', type: :request do
  describe 'POST /create' do
    it 'post追加ページを表示' do
      user = FactoryBot.create(:user)
      post_params = { user_id: '1', content: 'asdf' }
      # データが増えるか確認
      expect { post '/v1/posts', params: { post: post_params } }.to change(Post, :count).by(+1)
      # リクエストが成功するか確認
      expect(response.status).to eq(200)
    end
  end
end
