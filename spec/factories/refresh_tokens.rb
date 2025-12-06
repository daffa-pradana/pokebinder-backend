FactoryBot.define do
  factory :refresh_token do
    token { "MyString" }
    user { nil }
    expires_at { "2025-12-04 14:16:41" }
    revoked { false }
  end
end
