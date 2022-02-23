# require 'rails_helper'
# RSpec.describe 'User following', type: :request do
#   # let(:user) { FactoryBot.create(:user) }
#   # let(:other_users) { FactoryBot.create_list(:user, 20) }

#   # describe 'フォロー・フォロー解除の際にログイン要求' do
#   #   before do
#   #     other_users[0..9].each do |other_user|
#   #       user.active_relationships.create!(followed_id: other_user.id)
#   #       user.passive_relationships.create!(follower_id: other_user.id)
#   #     end
#   #     log_in_as(user)
#   #   end

#   #   it 'following page' do
#   #     pending 'テストが失敗するので後で直す'
#   #     get following_user_path(user)
#   #     expect(user.following).to be_truthy
#   #     assert_match user.following.count.to_s, response.body
#   #     user.following.each do |u|
#   #       expect(page).to have_link u.email, href: user_path(u)
#   #     end
#   #   end
#   # end

#   describe 'フォローボタンの動作' do
#     let(:user) { FactoryBot.create(:user) }
#     let(:other_users) { FactoryBot.create_list(:user, 20) }

#     before do
#       other_users[0..9].each do |other_user|
#         user.active_relationships.create!(followed_id: other_user.id)
#         user.passive_relationships.create!(follower_id: other_user.id)
#       end
#       log_in_as(user)
#     end

#     it 'should follow a user the standard way' do
#       expect do
#         post relationships_path, params: { followed_id: other_user.id }
#       end.to change(user.following, :count).by(1)
#     end

#     # it 'should follow a user with Ajax' do
#     #   assert_difference '@user.following.count', 1 do
#     #     post relationships_path, xhr: true, params: { followed_id: @other.id }
#     #   end
#     # end

#     # it 'should unfollow a user the standard way' do
#     #   @user.follow(@other)
#     #   relationship = @user.active_relationships.find_by(followed_id: @other.id)
#     #   assert_difference '@user.following.count', -1 do
#     #     delete relationship_path(relationship)
#     #   end
#     # end

#     # it 'should unfollow a user with Ajax' do
#     #   @user.follow(@other)
#     #   relationship = @user.active_relationships.find_by(followed_id: @other.id)
#     #   assert_difference '@user.following.count', -1 do
#     #     delete relationship_path(relationship), xhr: true
#     #   end
#     # end
#   end
# end
