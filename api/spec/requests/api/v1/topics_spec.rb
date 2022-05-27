require 'rails_helper'

RSpec.describe 'Api::V1::Topics', type: :request do
  describe 'topic /create' do
    it 'topic追加ページを表示' do
      user = FactoryBot.create(:user) # 無いとパスしないので一旦残す
      topic_params = { user_id: '1', title: 'title', content: 'content' }

      # データが増えるか確認
      expect { post '/v1/topics', params: { topic: topic_params } }.to change(Topic, :count).by(+1)

      # リクエストが成功するか確認
      expect(response.status).to eq(200)
    end
  end

  describe 'topic /index' do
    it 'topic一覧ページを表示' do
      topic = FactoryBot.create(:topic)
      other_topic = FactoryBot.create(:other_topic)
      get '/v1/topics'
      json = JSON.parse(response.body)

      # リクエストが成功するか確認
      expect(response.status).to eq(200)

      # 数が正しいか確認
      expect((json['topics'].length)).to eq(2)

      # 値が正しいか確認
      expect(json['topics'][1]['title']).to eq(topic.title)
      expect(json['topics'][0]['title']).to eq(other_topic.title)
    end
  end

  describe 'topic /show' do
    it 'topic詳細ページを表示' do
      topic = FactoryBot.create(:topic)
      get "/v1/topics/#{topic.id}"
      json = JSON.parse(response.body)

      # リクエストが成功するか確認
      expect(response.status).to eq(200)

      # 値が正しいか確認
      expect(json['title']).to eq(topic.title)
      expect(json['content']).to eq(topic.content)
    end
  end

  describe 'topic /update' do
    it 'topic情報の編集に成功' do
      topic = FactoryBot.create(:topic)
      put "/v1/topics/#{topic.id}", params: { topic: { title: 'new-title', content: 'new-content' } }
      json = JSON.parse(response.body)

      # リクエストが成功するか確認
      expect(response.status).to eq(200)

      # 値が変更できたか確認
      expect(json['title']).to eq('new-title')
      expect(json['content']).to eq('new-content')

      expect(json['title']).to_not eq('title1')
      expect(json['content']).to_not eq('content1')
    end

    it 'topic情報の編集に失敗' do
      topic = FactoryBot.create(:topic)
      put "/v1/topics/#{topic.id}", params: { topic: { title: '' } }
      json = JSON.parse(response.body)

      # リクエストが成功するか確認
      expect(response.status).to eq(200)

      # エラーが出るか確認
      expect(json['title']).to eq(['を入力してください'])
    end
  end

  describe 'topic /delete' do
    it 'topic削除ページを表示' do
      topic = FactoryBot.create(:topic)

      # データが減るか確認
      expect { delete "/v1/topics/#{topic.id}" }.to change(Topic, :count).by(-1)

      # リクエストが成功するか確認
      expect(response.status).to eq(200)
    end
  end
end
