require 'rails_helper'

RSpec.describe User, type: :model do
  it "is valid with valid attributes" do
    user = Fabricate.build(:user, name: "Valid_name-123")
    expect(user).to be_valid
  end

  it "is not valid without a name" do
    user = Fabricate.build(:user, name: nil)
    expect(user).to_not be_valid
    expect(user.errors[:name]).to include("can't be blank")
  end

  it "is not valid if name has already been taken" do
    Fabricate(:user, name: "Existent_name-123")

    user = Fabricate.build(:user, name: "Existent_name-123")
    expect(user).to_not be_valid
    expect(user.errors[:name]).to include("has already been taken")
  end

  it "is not valid if name has already been taken ignoring cases" do
    Fabricate(:user, name: "Existent_name-123")

    user = Fabricate.build(:user, name: "existent_name-123")
    expect(user).to_not be_valid
    expect(user.errors[:name]).to include("has already been taken")
  end

  it "is not valid if name is too long" do
    user = Fabricate.build(:user, name: "abcdefghijklmnopqrstuvwxyz")
    expect(user).to_not be_valid
    expect(user.errors[:name]).to include("is invalid")
  end

  it "is not valid if name is too short" do
    user = Fabricate.build(:user, name: "ab")
    expect(user).to_not be_valid
    expect(user.errors[:name]).to include("is invalid")
  end

  it "is not valid if name includes special character" do
    user = Fabricate.build(:user, name: "aßc123")
    expect(user).to_not be_valid
    expect(user.errors[:name]).to include("is invalid")

    user = Fabricate.build(:user, name: "abc.23")
    expect(user).to_not be_valid
    expect(user.errors[:name]).to include("is invalid")
  end

  it "is not valid if name includes whitespace" do
    user = Fabricate.build(:user, name: "abc 123")
    expect(user).to_not be_valid
    expect(user.errors[:name]).to include("is invalid")
  end
end
