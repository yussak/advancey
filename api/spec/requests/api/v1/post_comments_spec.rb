require 'rails_helper'

RSpec.describe 'Api::V1::PostComments', type: :request do
  describe 'post_comment /create' do
    it 'post_comment追加ページを表示' do
      pending('user post周りでうまくいかない')
      # user = FactoryBot.create(:user) # unusedだが消すとパスしない→一旦残す
      # post = FactoryBot.create(:post)
      comment_params = { user_id: '1', post_id: '1', content: 'content' }

      # データが増えるか確認
      expect do
        post '/v1/posts/1/post_comments', params: { comment: comment_params }
      end.to change(PostComment, :count).by(+1)

      # リクエストが成功するか確認
      expect(response.status).to eq(200)
    end
  end

  # describe 'post_comment /index' do
  #   it 'post_comment一覧ページを表示' do
  #     comment = FactoryBot.create(:post)
  #     other_comment = FactoryBot.create(:other_comment)
  #     get '/v1/post_comments'
  #     json = JSON.parse(response.body)

  #     # リクエストが成功するか確認
  #     expect(response.status).to eq(200)

  #     # 数が正しいか確認
  #     expect((json.length)).to eq(2)

  #     # 値が正しいか確認
  #     expect(json[1]['content']).to eq(post.content)
  #     expect(json[0]['content']).to eq(other_comment.content)
  #   end
  # end

  # describe 'post_comment /show' do
  #   it 'post_comment詳細ページを表示' do
  #     comment = FactoryBot.create(:post)
  #     get "/v1/post_comments/#{post.id}"
  #     json = JSON.parse(response.body)

  #     # リクエストが成功するか確認
  #     expect(response.status).to eq(200)

  #     # 値が正しいか確認
  #     expect(json['content']).to eq(post.content)
  #   end
  # end

  # describe 'post_comment /update' do
  #   it 'post_comment情報の編集に成功' do
  #     comment = FactoryBot.create(:post)
  #     put "/v1/post_comments/#{post.id}", params: { post: { content: 'new_content' } }
  #     json = JSON.parse(response.body)

  #     # リクエストが成功するか確認
  #     expect(response.status).to eq(200)

  #     # 値が変更できたか確認
  #     expect(json['content']).to eq('new_content')
  #     expect(json['content']).to_not eq('test1')
  #   end

  #   it 'post_comment情報の編集に失敗' do
  #     comment = FactoryBot.create(:post)
  #     put "/v1/post_comments/#{post.id}", params: { post: { content: '' } }
  #     json = JSON.parse(response.body)

  #     # リクエストが成功するか確認
  #     expect(response.status).to eq(200)

  #     # エラーが出るか確認
  #     expect(json['content']).to eq(['を入力してください'])
  #   end
  # end

  # describe 'post_comment /delete' do
  #   it 'post_comment削除ページを表示' do
  #     comment = FactoryBot.create(:post)

  #     # データが減るか確認
  #     expect { delete "/v1/post_comments/#{post.id}" }.to change(PostComment, :count).by(-1)

  #     # リクエストが成功するか確認
  #     expect(response.status).to eq(200)
  #   end
  # end
end
