require 'rails_helper'

RSpec.describe 'User controller', type: :request do
  let(:new_post) { FactoryBot.create(:post) }

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
end
