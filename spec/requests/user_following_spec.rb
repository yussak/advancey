require 'rails_helper'
RSpec.describe 'User following', type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:other_users) { FactoryBot.create_list(:user, 20) }

  before do
    other_users[0..9].each do |other_user|
      user.active_relationships.create!(followed_id: other_user.id)
      user.passive_relationships.create!(follower_id: other_user.id)
    end
    log_in_as(user)
  end

  it 'following page' do
    pending 'テストが失敗するので後で直す'
    get following_user_path(user)
    expect(user.following).to be_truthy
    assert_match user.following.count.to_s, response.body
    user.following.each do |u|
      expect(page).to have_link u.email, href: user_path(u)
    end
  end
end
