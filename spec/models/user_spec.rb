require 'rails_helper'

RSpec.describe User, type: :model do
  it "is valid with valid attributes" do
    user = Fabricate.build(:user, email: "valid@email.com", password: "password")
    expect(user).to be_valid
  end

  it "is not valid without an email" do
    user = Fabricate.build(:user, email: nil)
    expect(user).to_not be_valid
    expect(user.errors[:email]).to include("can't be blank")
  end

  it "is not valid with an invalid email" do
    user = Fabricate.build(:user, email: nil)
    expect(user).to_not be_valid
    expect(user.errors[:email]).to include("can't be blank")
  end

  it "is not valid if email has already been taken" do
    Fabricate(:user, email: "email@example.com")

    user = Fabricate.build(:user, email: "email@example.com")
    expect(user).to_not be_valid
    expect(user.errors[:email]).to include("has already been taken")
  end

  it "is not valid if email has already been taken ignoring cases" do
    Fabricate(:user, email: "email@example.com")

    user = Fabricate.build(:user, email: "Email@example.com")
    expect(user).to_not be_valid
    expect(user.errors[:email]).to include("has already been taken")
  end

  it "is not valid without a password" do
    user = Fabricate.build(:user, password: nil)
    expect(user).to_not be_valid
    expect(user.errors[:password]).to include("can't be blank")
  end

  it "is not valid with too short of a password" do
    user = Fabricate.build(:user, password: "123")
    expect(user).to_not be_valid
    expect(user.errors[:password]).to include("is too short (minimum is 6 characters)")
  end
end
