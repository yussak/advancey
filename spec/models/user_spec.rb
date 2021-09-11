require 'rails_helper'

RSpec.describe User, type: :model do
  
  user = User.new(name: "Example User", email: "user@example.com")
  it "is valid" do
    expect(user).to be_valid
  end

  it "is invalid without name" do
    user.name = " "
    expect(user).not_to be_valid
  end

  it "is invalid without email" do
    user.email = " "
    expect(user).not_to be_valid
  end

  it "has name that isn't too long" do
    user.name = "a" * 51
    expect(user).not_to be_valid
  end

  it "has email that isn't too long" do
    user.email = "a" * 244 + "@example.com"
    expect(user).not_to be_valid
  end

  it "email validation should accept valid addresses" do
    user.name="tarou"
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      user.email = valid_address
      expect(user).to be_valid, "#{valid_address.inspect} should be valid"
    end
  end
end
