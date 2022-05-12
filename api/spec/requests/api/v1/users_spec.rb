require 'rails_helper'

RSpec.describe 'Api::V1::Users', type: :request do
  describe 'GET /index' do
    it 'user一覧ページを表示' do
      user = FactoryBot.create(:user)
      other_user = FactoryBot.create(:other_user)
      get '/v1/users'
      json = JSON.parse(response.body)
      # リクエストが成功するか確認
      expect(response.status).to eq(200)
      # ユーザー数が正しいか確認
      expect((json.length)).to eq(2)
      # ユーザー名が正しいか確認
      expect(json[0]['name']).to eq(user.name)
      expect(json[0]['name']).to_not eq(other_user.name)
      # ユーザー名が正しくないか確認
      expect(json[1]['name']).to eq(other_user.name)
      expect(json[1]['name']).to_not eq(user.name)
    end
  end

  describe 'GET /show' do
    it 'user詳細ページを表示' do
      user = FactoryBot.create(:user)
      get "/v1/users/#{user.id}"
      json = JSON.parse(response.body)

      # リクエストが成功するか確認
      expect(response.status).to eq(200)
      # 値が正しいか確認
      expect(json['user']['name']).to eq(user.name)
      expect(json['user']['email']).to eq(user.email)
    end
  end

  describe 'PUT /update' do
    it 'user情報の編集に成功' do
      user = FactoryBot.create(:user)
      put "/v1/users/#{user.id}", params: {
        user: { name: 'new_name', profile: 'new_profile' }
      }
      json = JSON.parse(response.body)

      # リクエストが成功するか確認
      expect(response.status).to eq(200)
      # 値が変更できたか確認
      expect(json['name']).to eq('new_name')
      expect(json['name']).to_not eq('user1@aa.com')

      expect(json['profile']).to eq('new_profile')
      expect(json['profile']).to_not eq('よろしくお願いします！')
    end
  end
end
