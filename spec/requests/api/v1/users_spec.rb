require 'rails_helper'

RSpec.describe "Api::V1::Users", type: :request do
  let(:headers_json) { { "CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json" } }

  describe "POST /api/v1/users (signup)" do
    it "creates user" do
      params = { user: { name: "A", email: "a@example.com", password: "secret", password_confirmation: "secret" } }
      post "/api/v1/users", params: params.to_json, headers: headers_json
      expect(response).to have_http_status(:created)
      body = JSON.parse(response.body)
      expect(body["user"]["email"]).to eq("a@example.com")
    end

    it "returns errors for invalid data" do
      params = { user: { name: "" } }
      post "/api/v1/users", params: params.to_json, headers: headers_json
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  context "when authenticated" do
    let!(:user) { create(:user) }
    let(:auth_headers) { auth_headers_for(user) }

    describe "GET /api/v1/users/:id" do
      it "shows own profile" do
        get "/api/v1/users/#{user.id}", headers: auth_headers
        expect(response).to have_http_status(:ok)
        body = JSON.parse(response.body)
        expect(body["user"]["id"]).to eq(user.id)
      end

      it "forbids viewing other users" do
        other = create(:user)
        get "/api/v1/users/#{other.id}", headers: auth_headers
        expect(response).to have_http_status(:forbidden)
      end
    end

    describe "PATCH /api/v1/users/:id" do
      it "updates own profile" do
        params = { user: { name: "NewName" } }
        patch "/api/v1/users/#{user.id}", params: params.to_json, headers: auth_headers
        expect(response).to have_http_status(:ok)
        expect(user.reload.name).to eq("NewName")
      end
    end

    describe "DELETE /api/v1/users/:id" do
      it "deletes own user" do
        delete "/api/v1/users/#{user.id}", headers: auth_headers
        expect(response).to have_http_status(:no_content)
        expect { User.find(user.id) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
