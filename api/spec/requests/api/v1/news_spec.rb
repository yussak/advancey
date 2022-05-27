require 'rails_helper'

RSpec.describe 'Api::V1::News', type: :request do
  describe 'news /create' do
    it 'news追加ページを表示' do
      user = FactoryBot.create(:user) # 消すとパスしない→一旦残す
      news_params = { user_id: '1', content: 'content' }

      # データが増えるか確認
      expect { post '/v1/news', params: { news: news_params } }.to change(News, :count).by(+1)

      # リクエストが成功するか確認
      expect(response.status).to eq(200)
    end
  end

  describe 'news /index' do
    it 'news一覧ページを表示' do
      news = FactoryBot.create(:news)
      other_news = FactoryBot.create(:other_news)
      get '/v1/news'
      json = JSON.parse(response.body)

      # リクエストが成功するか確認
      expect(response.status).to eq(200)

      # 数が正しいか確認
      expect((json.length)).to eq(2)

      # 値が正しいか確認
      expect(json[1]['content']).to eq(news.content)
      expect(json[0]['content']).to eq(other_news.content)
    end
  end

  describe 'news /delete' do
    it 'news削除ページを表示' do
      news = FactoryBot.create(:news)

      # データが減るか確認
      expect { delete "/v1/news/#{news.id}" }.to change(News, :count).by(-1)

      # リクエストが成功するか確認
      expect(response.status).to eq(200)
    end
  end
end
