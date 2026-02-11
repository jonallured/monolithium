require "rails_helper"

describe "GET /api/v1/post_bin" do
  context "without a client token" do
    it "returns an empty 404" do
      get "/api/v1/post_bin"
      expect(response.status).to eq 404
    end
  end

  context "with an invalid client token header" do
    it "returns an empty 404" do
      headers = {ApiController::CLIENT_TOKEN_HEADER => "invalid"}
      get "/api/v1/post_bin", headers: headers
      expect(response.status).to eq 404
    end
  end

  context "with a valid client token header" do
    it "returns an empty 200 and creates a PostBin record" do
      headers = {ApiController::CLIENT_TOKEN_HEADER => Monolithium.config.client_token}
      get "/api/v1/post_bin", headers: headers
      expect(response.status).to eq 200
      expect(PostBinRequest.count).to eq 1
    end
  end

  context "with an invalid client token param" do
    it "returns an empty 404" do
      params = {ApiController::CLIENT_TOKEN_PARAM => "invalid"}
      get "/api/v1/post_bin", params: params
      expect(response.status).to eq 404
    end
  end

  context "with a valid client token param" do
    it "returns an empty 200 and creates a PostBin record" do
      params = {ApiController::CLIENT_TOKEN_PARAM => Monolithium.config.client_token}
      get "/api/v1/post_bin", params: params
      expect(response.status).to eq 200
      expect(PostBinRequest.count).to eq 1
    end
  end

  context "with an invalid client token header and a valid client token param" do
    it "returns an empty 404" do
      params = {ApiController::CLIENT_TOKEN_PARAM => Monolithium.config.client_token}
      headers = {ApiController::CLIENT_TOKEN_HEADER => "invalid"}
      get "/api/v1/post_bin", params: params, headers: headers
      expect(response.status).to eq 404
    end
  end

  context "with data for headers and params" do
    it "returns an empty 200 and captures that data" do
      headers = {
        ApiController::CLIENT_TOKEN_HEADER => Monolithium.config.client_token,
        "Sent-By" => "Me"
      }
      params = {"mode" => "hard"}

      get "/api/v1/post_bin", params: params, headers: headers

      expect(response.status).to eq 200
      post_bin_request = PostBinRequest.first
      expect(post_bin_request.body).to eq nil
      expect(post_bin_request.headers["HTTP_SENT_BY"]).to eq "Me"
      expect(post_bin_request.params["mode"]).to eq "hard"
    end
  end
end
