module AuthHelpers
  def auth_headers_for(user)
    access_token, = JwtService.encode_access(user_id: user.id) # expects your JwtService
    {
      "Authorization" => "Bearer #{access_token}",
      "CONTENT_TYPE" => "application/json",
      "ACCEPT" => "application/json"
    }
  end
end

RSpec.configure do |config|
  config.include AuthHelpers, type: :request
end
