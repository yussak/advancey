require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:post) { FactoryBot.create(:post) }

  it 'should be valid' do
    expect(post).to be_valid
  end

  it 'user id should be present' do
    post.user_id = nil
    expect(post).not_to be_valid
  end

  it 'content should be present' do
    post.content = '   '
    expect(post).not_to be_valid
  end

  it 'content should be at most 140 characters' do
    post.content = 'a' * 141
    expect(post).not_to be_valid
  end

  describe 'sort by latest' do
    let!(:day_before_yesterday) { FactoryBot.create(:post, :day_before_yesterday) }
    let!(:now) { FactoryBot.create(:post, :now) }
    let!(:yesterday) { FactoryBot.create(:post, :yesterday) }

    it 'succeeds' do
      expect(Post.first).to eq now
    end
  end
end
