require 'rails_helper'

RSpec.describe "Auth::Sessions", type: :request do
  describe "POST /auth/sign_in" do
    let!(:user) { create(:user, email: "test@example.com", password: "secret123", password_confirmation: "secret123") }

    it "returns tokens for valid credentials" do
      post "/auth/sign_in", params: { email: user.email, password: "secret123" }.to_json,
           headers: { "CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json" }

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body["access_token"]).to be_present
      expect(body["refresh_token"]).to be_present
      expect(body["user"]["email"]).to eq(user.email)
    end

    it "returns unauthorized for bad credentials" do
      post "/auth/sign_in", params: { email: user.email, password: "wrong" }.to_json,
           headers: { "CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json" }

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "DELETE /auth/sign_out" do
    let!(:user) { create(:user) }
    let!(:refresh) { user.refresh_tokens.create! } # ensure factory or model creates refresh token

    it "revokes refresh token when authenticated" do
      headers = auth_headers_for(user)
      delete "/auth/sign_out", params: { refresh_token: refresh.token }.to_json, headers: headers
      expect(response).to have_http_status(:ok)
      expect(refresh.reload.revoked).to be true
    end

    it "requires authentication" do
      delete "/auth/sign_out", params: { refresh_token: refresh.token }.to_json,
             headers: { "CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json" }
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
