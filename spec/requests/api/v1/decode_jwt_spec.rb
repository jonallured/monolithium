require "rails_helper"

describe "GET /api/v1/decode_jwt" do
  context "without a token" do
    it "returns 400" do
      get "/api/v1/decode_jwt"
      expect(response.status).to eq 400
    end
  end

  context "with an invalid token" do
    it "returns 400" do
      params = {token: "invalid"}
      get "/api/v1/decode_jwt", params: params
      expect(response.status).to eq 400
    end
  end

  context "with a valid token" do
    it "returns 200 with that token decoded" do
      alg = "none"
      payload = {foo: :bar}
      token = JWT.encode(payload, nil, alg)
      params = {token: token}

      get "/api/v1/decode_jwt", params: params

      expect(response.status).to eq 200
      expect(response.parsed_body).to eq({
        "headers" => {"alg" => "none"},
        "payload" => {"foo" => "bar"},
        "token" => token
      })
    end
  end
end
