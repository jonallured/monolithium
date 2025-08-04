require "rails_helper"

describe "POST /api/v1/gift_ideas" do
  let(:headers) { {ApiController::CLIENT_TOKEN_HEADER => Monolithium.config.client_token} }

  context "without required param" do
    let(:params) { {} }

    it "returns 400 and an error message" do
      post "/api/v1/gift_ideas", params: params, headers: headers

      expect(response.status).to eq 400
      expect(response.body).to match "param is missing"
    end
  end

  context "without required attributes" do
    let(:params) { {gift_idea: {foo: :bar}} }

    it "returns 400 and an error message" do
      post "/api/v1/gift_ideas", params: params, headers: headers

      expect(response.status).to eq 400
      expect(response.body).to match "Validation failed"
    end
  end

  context "with invalid required attributes" do
    let(:params) { {gift_idea: {title: nil, website_url: nil}} }

    it "returns 400 and an error message" do
      post "/api/v1/gift_ideas", params: params, headers: headers

      expect(response.status).to eq 400
      expect(response.body).to match "Validation failed"
    end
  end

  context "with valid required attributes" do
    let(:params) do
      {
        gift_idea: {
          title: "New Mario Game",
          website_url: "https://www.nintendo.com/new-mario-game"
        }
      }
    end

    it "returns 201 and the json for the gift_idea" do
      post "/api/v1/gift_ideas", params: params, headers: headers

      expect(response.status).to eq 201
      expect(response.parsed_body).to match({
        "created_at" => anything,
        "id" => anything,
        "note" => nil,
        "website_url" => "https://www.nintendo.com/new-mario-game",
        "title" => "New Mario Game",
        "updated_at" => anything
      })
    end
  end

  context "with bonus attribute" do
    let(:zero_time) { Time.at(0).utc }

    let(:params) do
      {
        gift_idea: {
          created_at: zero_time,
          title: "New Mario Game",
          website_url: "https://www.nintendo.com/new-mario-game"
        }
      }
    end

    it "ignores bonus attributes" do
      post "/api/v1/gift_ideas", params: params, headers: headers

      expect(response.status).to eq 201
      expect(response.parsed_body["created_at"]).to_not eq zero_time.as_json
    end
  end
end
