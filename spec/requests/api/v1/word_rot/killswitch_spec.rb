require "rails_helper"

describe "GET /api/v1/word_rot/killswitch" do
  it "returns the instance info" do
    get "/api/v1/word_rot/killswitch"

    expect(response.status).to eq 200
    expect(response.parsed_body).to eq(
      {
        "bad_builds" => [],
        "minimum_build" => 3
      }
    )
  end
end
