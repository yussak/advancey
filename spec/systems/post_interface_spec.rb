require 'rails_helper'

RSpec.describe 'User controller', type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:new_post) { FactoryBot.create(:post) }

  scenario 'post interface' do
    log_in_as(user)
    expect(is_logged_in?).to be_truthy

    # 無効な送信
    # click_link 'Post' # Unable to find link "Post"
    # click_button 'Post' # Unable to find button "Post" that is not disabled
    # click_on 'Post' # Unable to find link or button "Post"
    # expect(has_css?('.alert-danger')).to be_truthy
    # expect(flash[:danger]).to be_truthy

    # 有効な送信
    valid_content = 'This post really ties the room together'
    fill_in 'post_content', with: valid_content
    expect do
      click_on 'Post'
      expect(current_path).to eq root_path
      expect(has_css?('.alert-success')).to be_truthy
    end.to change(post, :count).by(1)

    # 投稿を削除する
    expect do
      page.accept_confirm do
        all('ol li')[0].click_on 'delete'
      end
      expect(current_path).to eq root_path
      expect(has_css?('.alert-success')).to be_truthy
    end.to change(post, :count).by(-1)

    # 違うユーザのプロフィールにアクセス(削除リンクがないことを確認)
    visit user_path(post.user)
    expect(page).not_to have_link 'delete'
  end
end
