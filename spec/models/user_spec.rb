require 'rails_helper'

RSpec.describe User, type: :model do
  
  user = User.new(name: "Example User", email: "user@example.com")
  it "is valid" do
    expect(user).to be_valid
  end

  it "has no name" do
    user.name = " "
    expect(user).not_to be_valid
  end

  it "has no email" do
    user.email = " "
    expect(user).not_to be_valid
  end
end
