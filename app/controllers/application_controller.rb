class ApplicationController < ActionController::API
  include ActionController::RequestForgeryProtection
  protect_from_forgery with: :null_session

  before_action :authenticate_request!

  attr_reader :current_user

  private

  def authenticate_request!
    token = bearer_token
    return render json: { error: "Missing token" }, status: :unauthorized unless token

    begin
      payload = JwtService.decode(token)
      return render json: { error: "Invalid token type" }, status: :unauthorized unless payload["typ"] == "access"

      @current_user = User.find_by(id: payload["user_id"])
      render json: { error: "User not found" }, status: :unauthorized unless @current_user
    rescue JWT::ExpiredSignature
      render json: { error: "Access token expired" }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: { error: "Invalid token: #{e.message}" }, status: :unauthorized
    end
  end

  def bearer_token
    auth = request.headers["Authorization"]
    return nil unless auth.present? && auth.start_with?("Bearer ")
    auth.split(" ", 2).last
  end
end
