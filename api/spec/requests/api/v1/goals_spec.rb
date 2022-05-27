require 'rails_helper'

RSpec.describe 'Api::V1::Goals', type: :request do
  describe 'goal /create' do
    it 'goal追加ページを表示' do
      user = FactoryBot.create(:user) # 消すとパスしない→一旦残す
      goal_params = { user_id: '1', content: 'content', reason: 'reason', todo: 'todo' }

      # データが増えるか確認
      expect { post '/v1/goals', params: { goal: goal_params } }.to change(Goal, :count).by(+1)

      # リクエストが成功するか確認
      expect(response.status).to eq(200)
    end
  end

  describe 'goal /index' do
    it 'goal一覧ページを表示' do
      goal = FactoryBot.create(:goal)
      other_goal = FactoryBot.create(:other_goal)
      get '/v1/goals'
      json = JSON.parse(response.body)

      # リクエストが成功するか確認
      expect(response.status).to eq(200)

      # 数が正しいか確認
      expect((json['goals'].length)).to eq(2)

      # 値が正しいか確認
      expect(json['goals'][1]['content']).to eq(goal.content)
      expect(json['goals'][0]['content']).to eq(other_goal.content)
    end
  end

  describe 'goal /show' do
    it 'goal詳細ページを表示' do
      goal = FactoryBot.create(:goal)
      get "/v1/goals/#{goal.id}"
      json = JSON.parse(response.body)

      # リクエストが成功するか確認
      expect(response.status).to eq(200)

      # 値が正しいか確認
      expect(json['content']).to eq(goal.content)
    end
  end

  describe 'goal /update' do
    it 'goal情報の編集に成功' do
      goal = FactoryBot.create(:goal)
      put "/v1/goals/#{goal.id}", params: { goal: { content: 'new_content' } }
      json = JSON.parse(response.body)

      # リクエストが成功するか確認
      expect(response.status).to eq(200)

      # 値が変更できたか確認
      expect(json['content']).to eq('new_content')
      expect(json['content']).to_not eq('test1')
    end

    it 'goal情報の編集に失敗' do
      goal = FactoryBot.create(:goal)
      put "/v1/goals/#{goal.id}", params: { goal: { content: '', reason: '', todo: '' } }
      json = JSON.parse(response.body)

      # リクエストが成功するか確認
      expect(response.status).to eq(200)

      # エラーが出るか確認
      expect(json['content']).to eq(['を入力してください'])
      expect(json['reason']).to eq(['を入力してください'])
      expect(json['todo']).to eq(['を入力してください'])
    end
  end

  describe 'goal /delete' do
    it 'goal削除ページを表示' do
      goal = FactoryBot.create(:goal)

      # データが減るか確認
      expect { delete "/v1/goals/#{goal.id}" }.to change(Goal, :count).by(-1)

      # リクエストが成功するか確認
      expect(response.status).to eq(200)
    end
  end
end
