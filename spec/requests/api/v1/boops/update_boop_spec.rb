require "rails_helper"

describe "PUT /api/v1/boops/:id" do
  let(:headers) { {ApiController::CLIENT_TOKEN_HEADER => Monolithium.config.client_token} }

  context "with an invalid id" do
    it "returns 404 and an error message" do
      put "/api/v1/boops/invalid", headers: headers

      expect(response.status).to eq 404
      expect(response.body).to match "Couldn't find Boop"
    end
  end

  context "without required param" do
    let(:boop) { FactoryBot.create(:boop) }
    let(:params) { {} }

    it "returns 400 and an error message" do
      put "/api/v1/boops/#{boop.id}", params: params, headers: headers

      expect(response.status).to eq 400
      expect(response.body).to match "param is missing"
    end
  end

  context "with an invalid update" do
    let(:boop) { FactoryBot.create(:boop) }
    let(:params) { {boop: {display_type: "invalid"}} }

    it "returns 400 and an error message" do
      put "/api/v1/boops/#{boop.id}", params: params, headers: headers

      expect(response.status).to eq 400
      expect(response.body).to match "Validation failed"
    end
  end

  context "with a valid id and update" do
    let(:boop) { FactoryBot.create(:boop, display_type: "skull") }
    let(:params) { {boop: {display_type: "smile"}} }

    it "returns 200 and the updated json" do
      put "/api/v1/boops/#{boop.id}", params: params, headers: headers

      expect(response.status).to eq 200
      expect(response.parsed_body["display_type"]).to eq "smile"
    end
  end

  context "with bonus attribute" do
    let(:boop) { FactoryBot.create(:boop) }
    let(:zero_time) { Time.at(0).utc }
    let(:params) { {boop: {created_at: zero_time}} }

    it "ignores bonus attributes" do
      put "/api/v1/boops/#{boop.id}", params: params, headers: headers

      expect(response.status).to eq 200
      expect(response.parsed_body["created_at"]).to_not eq zero_time.as_json
    end
  end
end
