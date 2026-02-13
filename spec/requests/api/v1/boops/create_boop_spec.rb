require "rails_helper"

describe "POST /api/v1/boops" do
  let(:headers) { {ApiController::CLIENT_TOKEN_HEADER => Monolithium.config.client_token} }

  context "without required param" do
    let(:params) { {} }

    it "returns 400 and an error message" do
      post "/api/v1/boops", params: params, headers: headers

      expect(response.status).to eq 400
      expect(response.body).to match "param is missing"
    end
  end

  context "without required attributes" do
    let(:params) { {boop: {foo: :bar}} }

    it "returns 400 and an error message" do
      post "/api/v1/boops", params: params, headers: headers

      expect(response.status).to eq 400
      expect(response.body).to match "Validation failed"
    end
  end

  context "with invalid required attributes" do
    let(:params) do
      {
        boop: {
          display_type: "invalid",
          number: "invalid"
        }
      }
    end

    it "returns 400 and an error message" do
      post "/api/v1/boops", params: params, headers: headers

      expect(response.status).to eq 400
      expect(response.body).to match "Validation failed"
    end
  end

  context "with valid required attributes" do
    let(:params) do
      {
        boop: {
          display_type: "skull",
          number: 1
        }
      }
    end

    it "returns 201 and the json for the boop" do
      post "/api/v1/boops", params: params, headers: headers

      expect(response.status).to eq 201
      expect(response.parsed_body).to match({
        "created_at" => anything,
        "dismissed_at" => nil,
        "display_type" => "skull",
        "id" => anything,
        "number" => 1,
        "updated_at" => anything
      })
    end
  end

  context "with bonus attribute" do
    let(:zero_time) { Time.at(0).utc }

    let(:params) do
      {
        boop: {
          created_at: zero_time,
          display_type: "skull",
          number: 1
        }
      }
    end

    it "ignores bonus attributes" do
      post "/api/v1/boops", params: params, headers: headers

      expect(response.status).to eq 201
      expect(response.parsed_body["created_at"]).to_not eq zero_time.as_json
    end
  end

  context "with valid required attributes and no client token" do
    let(:params) do
      {
        boop: {
          display_type: "skull"
        }
      }
    end

    it "returns 201 and the json for the boop" do
      post "/api/v1/boops", params: params

      expect(response.status).to eq 201
      expect(response.parsed_body).to match({
        "created_at" => anything,
        "dismissed_at" => nil,
        "display_type" => "skull",
        "id" => anything,
        "number" => 1,
        "updated_at" => anything
      })
    end
  end
end
