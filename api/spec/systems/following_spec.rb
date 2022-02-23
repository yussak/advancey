require 'rails_helper'

RSpec.describe 'Followings', type: :system do
  let(:user) { FactoryBot.create(:user) }
  # let(:other_users) { FactoryBot.create_list(:user, 20) }
  let(:other_user) { FactoryBot.create_list(:user, 20) } #作るなら1人では？

  before do
    # other_users[0..9].each do |other_user|
    #   user.active_relationships.create!(followed_id: other_user.id)
    #   user.passive_relationships.create!(follower_id: other_user.id)
    # end
    user.active_relationships.create!(followed_id: other_user.id)
    user.passive_relationships.create!(follower_id: other_user.id)
    log_in_as(user)
  end

  scenario 'When user clicks on Follow, the number of following increases by 1' do
    visit user_path(other_users.last.id)
    expect do
      click_on 'Follow'
      expect(page).not_to have_link 'Follow'
      # Ajaxの処理待ちの為に入れています
      visit current_path
    end.to change(user.following, :count).by(1)
  end

  # scenario 'When user clicks on Unfollow, the number of following increases by -1' do
  #   visit user_path(other_users.first.id)
  #   expect do
  #     click_on 'Unfollow'
  #     expect(page).not_to have_link 'Unfollow'
  #     # Ajaxの処理待ちの為に入れています
  #     visit current_path
  #   end.to change(user.following, :count).by(-1)
  # end
end
