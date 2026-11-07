require "rails_helper"

describe "GET /api/v1/check" do
  let(:headers) { {ApiController::CLIENT_TOKEN_HEADER => Monolithium.config.client_token} }

  context "with a valid token" do
    it "returns a 200" do
      get "/api/v1/check", headers: headers

      expect(response.status).to eq 200
    end

    it "returns the current time" do
      freeze_time do
        get "/api/v1/check", headers: headers

        expect(response.body).to eq Time.now.to_i.to_s
      end
    end
  end

  context "with an invalid token" do
    let(:headers) { {ApiController::CLIENT_TOKEN_HEADER => "invalid"} }

    it "returns a 404" do
      get "/api/v1/check", headers: headers

      expect(response.status).to eq 404
    end
  end

  context "without a token" do
    it "returns a 404" do
      get "/api/v1/check"

      expect(response.status).to eq 404
    end
  end

  context "when the configured token is blank" do
    before { allow(Monolithium.config).to receive(:client_token).and_return(nil) }

    it "returns a 404 without a token" do
      get "/api/v1/check"

      expect(response.status).to eq 404
    end

    it "returns a 404 with an empty token" do
      get "/api/v1/check", headers: {ApiController::CLIENT_TOKEN_HEADER => ""}

      expect(response.status).to eq 404
    end
  end
end
