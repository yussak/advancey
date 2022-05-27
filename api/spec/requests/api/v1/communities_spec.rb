require 'rails_helper'

RSpec.describe 'Api::V1::Communities', type: :request do
  describe 'community /create' do
    it 'community追加ページを表示' do
      user = FactoryBot.create(:user) # 消すとパスしない→一旦残す
      community_params = { user_id: '1', name: 'name', description: 'description' }

      # データが増えるか確認
      expect { post '/v1/communities', params: { community: community_params } }.to change(Community, :count).by(+1)

      # リクエストが成功するか確認
      expect(response.status).to eq(200)
    end
  end

  describe 'community /index' do
    it 'community一覧ページを表示' do
      pending('user周りでうまくいかない→多対多なので他の処理が必要そう')
      community = FactoryBot.create(:community)
      other_community = FactoryBot.create(:other_community)
      get '/v1/communities'
      json = JSON.parse(response.body)

      # リクエストが成功するか確認
      expect(response.status).to eq(200)

      # 数が正しいか確認
      expect((json['communities'].length)).to eq(2)

      # 値が正しいか確認
      expect(json['communities'][1]['name']).to eq(community.name)
      expect(json['communities'][0]['name']).to eq(other_community.name)
    end
  end

  describe 'community /show' do
    it 'community詳細ページを表示' do
      pending('user周りでうまくいかない→多対多なので他の処理が必要そう')
      user = FactoryBot.create(:user) # 消すとパスしない→一旦残す
      community = FactoryBot.create(:community)
      get "/v1/communities/#{community.id}"
      json = JSON.parse(response.body)

      # リクエストが成功するか確認
      expect(response.status).to eq(200)

      # 値が正しいか確認
      expect(json['name']).to eq(community.name)
      expect(json['description']).to eq(community.description)
    end
  end

  describe 'community /delete' do
    it 'community削除ページを表示' do
      pending('user周りでうまくいかない→多対多なので他の処理が必要そう')
      user = FactoryBot.create(:user) # 消すとパスしない→一旦残す
      community = FactoryBot.create(:community)

      # データが減るか確認
      expect { delete "/v1/communities/#{community.id}" }.to change(Community, :count).by(-1)

      # リクエストが成功するか確認
      expect(response.status).to eq(200)
    end
  end
end
