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

  describe 'GET /index' do
    it 'post一覧ページを表示' do
      post = FactoryBot.create(:post)
      other_post = FactoryBot.create(:other_post)
      get '/v1/posts'
      json = JSON.parse(response.body)
      # リクエストが成功するか確認
      expect(response.status).to eq(200)
      # ユーザー数が正しいか確認
      expect((json.length)).to eq(2)

      expect(json[1]['content']).to eq(post.content)
      expect(json[0]['content']).to eq(other_post.content)
    end
  end
end
