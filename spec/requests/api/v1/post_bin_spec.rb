require "rails_helper"

describe "POST /api/v1/post_bin" do
  context "without a client token" do
    it "returns an empty 404" do
      post "/api/v1/post_bin"
      expect(response.status).to eq 404
    end
  end

  context "with an invalid client token" do
    it "returns an empty 404" do
      headers = {"X-Client-Token" => "invalid"}
      post "/api/v1/post_bin", headers: headers
      expect(response.status).to eq 404
    end
  end

  context "with a valid client token" do
    it "returns an empty 201 and creates a PostBin record" do
      headers = {"X-Client-Token" => Monolithium.config.client_token}
      post "/api/v1/post_bin", headers: headers
      expect(response.status).to eq 201
      expect(PostBinRequest.count).to eq 1
    end
  end
end