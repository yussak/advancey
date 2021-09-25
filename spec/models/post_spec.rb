require 'rails_helper'

RSpec.describe Post, type: :model do
  before do
    @user = FactoryBot.create(:user)
    @post = Post.new(content: 'Lorem ipsum', user_id: @user.id)
  end

  it 'should be valid' do
    expect(@post).to be_valid
  end

  it 'user id should be present' do
    @post.user_id = nil
    expect(@post).not_to be_valid
  end

  it 'content should be present' do
    @post.content = '   '
    expect(@post).not_to be_valid
  end

  it 'content should be at most 140 characters' do
    @post.content = 'a' * 141
    expect(@post).not_to be_valid
  end
end
