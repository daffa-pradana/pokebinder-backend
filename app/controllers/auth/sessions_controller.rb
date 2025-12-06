module Auth
  class SessionsController < ApplicationController
    skip_before_action :authenticate_request!, only: [ :create ]

    def create
      user = User.find_by(email: params[:email]&.downcase)
      if user&.authenticate(params[:password])
        access_token, payload = JwtService.encode_access(user_id: user.id)
        refresh = user.refresh_tokens.create! # uses model callback to set token/expires
        render json: {
          access_token: access_token,
          access_expires_at: Time.at(payload[:exp]).iso8601,
          refresh_token: refresh.token,
          refresh_expires_at: refresh.expires_at.iso8601,
          user: user.as_json(only: [ :id, :name, :email ])
        }
      else
        render json: { error: "Invalid email or password" }, status: :unauthorized
      end
    end

    def destroy
      token = params[:refresh_token] || request.headers["X-Refresh-Token"]
      unless token
        return render json: { error: "Missing refresh token" }, status: :bad_request
      end

      refresh = current_user.refresh_tokens.find_by(token: token)
      if refresh
        refresh.revoke!
        render json: { message: "Signed out" }, status: :ok
      else
        render json: { error: "Refresh token not found" }, status: :not_found
      end
    end
  end
end
