require "rails_helper"

RSpec.describe User, type: :model do
  it "is valid with name, email, password" do
    user = build(:user)
    expect(user).to be_valid
  end

  it "is invalid without email" do
    user = build(:user, email: nil)
    expect(user).not_to be_valid
    expect(user.errors[:email]).to include("can't be blank")
  end

  it "enforces unique email" do
    create(:user, email: "dup@example.com")
    user = build(:user, email: "dup@example.com")
    expect(user).not_to be_valid
    expect(user.errors[:email]).to include("has already been taken")
  end
end
