require 'rails_helper'

RSpec.describe 'User controller', type: :request do
  before do
    @post = posts(:orange)
  end

  it 'should redirect create when not logged in' do
    assert_no_difference 'Post.count' do
      post posts_path, params: { post: { content: 'Lorem ipsum' } }
    end
    expect(response).to redirect_to login_path
  end

  it 'should redirect destroy when not logged in' do
    assert_no_difference 'Post.count' do
      delete post_path(@post)
    end
    expect(response).to redirect_to login_path
  end
end
