require 'rails_helper'

RSpec.describe 'Relationships', type: :request do
  describe 'フォロー時' do
    let(:post_request) { post relationships_path }
    it 'フォロー時にログイン要求' do
      expect { post_request }.to change(Relationship, :count).by(0)
      expect(response).to redirect_to login_url
    end
  end

  describe 'フォロー解除時' do
    let(:other_user) { FactoryBot.create(:user) }
    let(:delete_request) { delete relationship_path(other_user) }
    it 'フォロー解除時にログイン要求' do
      expect { delete_request }.to change(Relationship, :count).by(0)
      expect(response).to redirect_to login_url
    end
  end
end
