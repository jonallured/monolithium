require "rails_helper"

describe "GET /api/v1/time_clock/frames" do
  it "returns a 200 with the default frame" do
    params = {ApiController::CLIENT_TOKEN_PARAM => Monolithium.config.client_token}
    get "/api/v1/time_clock/frames", params: params
    expect(response.status).to eq 200
    expect(response.parsed_body).to eq(
      {
        "frames" => [
          {
            "icon" => 71783,
            "text" => "live"
          }
        ]
      }
    )
  end
end
