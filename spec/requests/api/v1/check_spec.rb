require "rails_helper"

describe "GET /api/v1/check" do
  context "without a token" do
    it "returns a 404" do
      get "/api/v1/check"

      expect(response.status).to eq 404
    end
  end

  context "with an invalid token" do
    let(:headers) { {ApiController::CLIENT_TOKEN_HEADER => "invalid"} }

    it "returns a 404" do
      get "/api/v1/check", headers: headers

      expect(response.status).to eq 404
    end
  end

  context "with a valid token" do
    let(:headers) { {ApiController::CLIENT_TOKEN_HEADER => Monolithium.config.client_token} }

    it "returns the current time" do
      freeze_time do
        get "/api/v1/check", headers: headers

        expect(response.status).to eq 200
        expect(response.body).to eq Time.now.to_i.to_s
      end
    end
  end
end
