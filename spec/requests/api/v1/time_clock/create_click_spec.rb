require "rails_helper"

describe "GET /api/v1/time_clock/clicks" do
  it "returns a 200 with an empty body" do
    params = {ApiController::CLIENT_TOKEN_PARAM => Monolithium.config.client_token}
    get "/api/v1/time_clock/clicks", params: params
    expect(response.status).to eq 200
    expect(response.body).to eq ""
  end
end
