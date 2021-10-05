require 'rails_helper'

RSpec.describe 'relationships', type: :request do
  let(:relationship) { FactoryBot.create(:relationship) }

  it 'should be valid' do
    expect(relationship).to be_valid
  end

  it 'should require a follower_id' do
    relationship.follower_id = nil
    expect(relationship).not_to be_valid
x  end

  it 'should require a followed_id' do
    relationship.followed_id = nil
    expect(relationship).not_to be_valid
  end
end
