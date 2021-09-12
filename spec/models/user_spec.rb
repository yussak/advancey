require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user){ build :user}

    it "is valid" do
      expect(user).to be_valid
    end
  
    it "is invalid without name" do
      user.name = " "
      expect(user).to be_invalid
    end
  
    it "is invalid without email" do
      user.email = " "
      expect(user).to be_invalid
    end

  it "has name that isn't too long" do
    user.name = "a" * 51
    expect(user).to be_invalid
  end

  it "has email that isn't too long" do
    user.email = "a" * 244 + "@example.com"
    expect(user).to be_invalid
  end

  it "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      user.email = valid_address
      expect(user).to be_valid, "#{valid_address.inspect} should be valid"
    end
  end

  it "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com foo@bar..com]
    invalid_addresses.each do |invalid_address|
      user.email = invalid_address
      expect(user).to be_invalid, "#{invalid_address.inspect} should be invalid"
    end
  end

  it "email addresses should be unique" do
    duplicate_user = user.dup
    user.save
    expect(duplicate_user).to be_invalid
  end

  it "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    user.email = mixed_case_email
    user.save
    assert_equal mixed_case_email.downcase, user.reload.email
  end
end
