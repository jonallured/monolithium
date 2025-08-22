require "rails_helper"

describe "POST /api/v1/vanishing_messages" do
  let(:headers) { {ApiController::CLIENT_TOKEN_HEADER => Monolithium.config.client_token} }

  context "without required param" do
    let(:params) { {} }

    it "returns 400" do
      post "/api/v1/vanishing_messages", params: params, headers: headers
      expect(response.status).to eq 400
    end
  end

  context "with valid required param" do
    let(:params) { {body: "top secret message!"} }

    it "returns 201 and sends the broadcast" do
      expected_payload = {body: "top secret message!", created_at: anything}
      expect(VanishingBoxChannel).to receive(:broadcast).with(expected_payload)
      post "/api/v1/vanishing_messages", params: params, headers: headers
      expect(response.status).to eq 201
    end
  end
end
