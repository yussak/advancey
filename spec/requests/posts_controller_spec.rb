require 'rails_helper'

RSpec.describe 'User controller', type: :request do
  let(:new_post) { FactoryBot.create(:post) }
  let(:user) { FactoryBot.create(:user) }

  it 'should redirect create when not logged in' do
    expect do
      post posts_path, params: { post: { content: 'Lorem ipsum' } }
    end.to change(Post, :count).by(0)
    expect(response).to redirect_to login_path
  end

  it 'should redirect destroy when not logged in' do
    expect do
      delete post_path(:new_post)
    end.to change(Post, :count).by(0)
    expect(response).to redirect_to login_path
  end

  context 'when logged in user try to delete others post' do
    let(:user) { FactoryBot.create(:user) }
    before { log_in_as(user) }

    it 'should redirect destroy for wrong post' do
      expect do
        delete post_path(:new_post)
      end.to change(Post, :count).by(0)
      expect(response).to redirect_to root_path
    end
  end
end
