require 'rails_helper'

RSpec.describe 'User follow', type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }

  it 'should follow and unfollow a user' do
    expect(user.following?(other_user)).to be_falsey
    user.follow(other_user)
    expect(user.following?(other_user)).to be_truthy
    expect(other_user.followers.include?(user)).to be_truthy
    user.unfollow(other_user)
    expect(user.following?(other_user)).to be_falsey
  end

  it 'should redirect following when not logged in' do
    get following_user_path(user)
    expect(response).to redirect_to login_url
  end

  it 'should redirect followers when not logged in' do
    get followers_user_path(user)
    expect(response).to redirect_to login_url
  end
end
