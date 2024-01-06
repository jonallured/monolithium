require "rails_helper"

describe "POST /api/v1/post_bin" do
  context "without a client token" do
    it "returns an empty 404" do
      post "/api/v1/post_bin"
      expect(response.status).to eq 404
    end
  end

  context "with an invalid client token header" do
    it "returns an empty 404" do
      headers = {ApiController::CLIENT_TOKEN_HEADER => "invalid"}
      post "/api/v1/post_bin", headers: headers
      expect(response.status).to eq 404
    end
  end

  context "with a valid client token header" do
    it "returns an empty 201 and creates a PostBin record" do
      headers = {ApiController::CLIENT_TOKEN_HEADER => Monolithium.config.client_token}
      post "/api/v1/post_bin", headers: headers
      expect(response.status).to eq 201
      expect(PostBinRequest.count).to eq 1
    end
  end

  context "with an invalid client token param" do
    it "returns an empty 404" do
      params = {ApiController::CLIENT_TOKEN_PARAM => "invalid"}
      post "/api/v1/post_bin", params: params
      expect(response.status).to eq 404
    end
  end

  context "with a valid client token param" do
    it "returns an empty 201 and creates a PostBin record" do
      params = {ApiController::CLIENT_TOKEN_PARAM => Monolithium.config.client_token}
      post "/api/v1/post_bin", params: params
      expect(response.status).to eq 201
      expect(PostBinRequest.count).to eq 1
    end
  end

  context "with an invalid client token header and a valid client token param" do
    it "returns an empty 404" do
      params = {ApiController::CLIENT_TOKEN_PARAM => Monolithium.config.client_token}
      headers = {ApiController::CLIENT_TOKEN_HEADER => "invalid"}
      post "/api/v1/post_bin", params: params, headers: headers
      expect(response.status).to eq 404
    end
  end
end
