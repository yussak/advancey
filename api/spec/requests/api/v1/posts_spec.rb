require 'rails_helper'

RSpec.describe 'Api::V1::Posts', type: :request do
  describe 'post /create' do
    it 'post追加ページを表示' do
      user = FactoryBot.create(:user)
      post_params = { user_id: '1', content: 'asdf' }
      # データが増えるか確認
      expect { post '/v1/posts', params: { post: post_params } }.to change(Post, :count).by(+1)
      # リクエストが成功するか確認
      expect(response.status).to eq(200)
    end
  end

  describe 'post /index' do
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

  describe 'post /show' do
    it 'post詳細ページを表示' do
      post = FactoryBot.create(:post)
      get "/v1/posts/#{post.id}"
      json = JSON.parse(response.body)
      # リクエストが成功するか確認
      expect(response.status).to eq(200)
      # 値が正しいか確認
      expect(json['content']).to eq(post.content)
    end
  end

  describe 'post /update' do
    it 'post情報の編集に成功' do
      post = FactoryBot.create(:post)
      put "/v1/posts/#{post.id}", params: { post: { content: 'new_content' } }
      json = JSON.parse(response.body)
      # リクエストが成功するか確認
      expect(response.status).to eq(200)
      # 値が変更できたか確認
      expect(json['content']).to eq('new_content')
      expect(json['content']).to_not eq('user1@aa.com')
    end

    it 'post情報の編集に失敗' do
      post = FactoryBot.create(:post)
      put "/v1/posts/#{post.id}", params: { post: { content: '' } }
      json = JSON.parse(response.body)
      # リクエストが成功するか確認
      expect(response.status).to eq(200)
      # エラーが出るか確認
      expect(json['content']).to eq(['を入力してください'])
    end
  end

  describe 'post /delete' do
    it 'post削除ページを表示' do
      post = FactoryBot.create(:post)
      # データが減るか確認
      expect { delete "/v1/posts/#{post.id}" }.to change(Post, :count).by(-1)
      # リクエストが成功するか確認
      expect(response.status).to eq(200)
    end
  end
end
