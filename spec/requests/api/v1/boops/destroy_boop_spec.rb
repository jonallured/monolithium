require "rails_helper"

describe "DELETE /api/v1/boops/:id" do
  let(:headers) { {ApiController::CLIENT_TOKEN_HEADER => Monolithium.config.client_token} }

  context "with an invalid id" do
    it "returns 404 and an error message" do
      delete "/api/v1/boops/invalid", headers: headers

      expect(response.status).to eq 404
      expect(response.body).to match "Couldn't find Boop"
    end
  end

  context "with a valid id" do
    let(:boop) { FactoryBot.create(:boop) }

    it "returns 200 and destroys that record" do
      delete "/api/v1/boops/#{boop.id}", headers: headers

      expect(response.status).to eq 200
      expect(Boop.where(id: boop.id).count).to eq 0
    end
  end
end
