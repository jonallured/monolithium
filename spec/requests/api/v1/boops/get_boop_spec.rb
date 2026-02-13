require "rails_helper"

describe "GET /api/v1/boops/:id" do
  let(:headers) { {ApiController::CLIENT_TOKEN_HEADER => Monolithium.config.client_token} }

  context "with invalid id" do
    it "returns 404" do
      get "/api/v1/boops/invalid", headers: headers

      expect(response.status).to eq 404
      expect(response.body).to match "Couldn't find Boop"
    end
  end

  context "with a valid id" do
    it "returns the json for that record" do
      boop = FactoryBot.create(
        :boop,
        display_type: "skull",
        number: 1
      )

      get "/api/v1/boops/#{boop.id}", headers: headers

      expect(response.status).to eq 200
      expect(response.parsed_body).to match({
        "created_at" => anything,
        "dismissed_at" => nil,
        "display_type" => "skull",
        "id" => boop.id,
        "number" => 1,
        "updated_at" => anything
      })
    end
  end

  context "with random id" do
    it "returns a random record" do
      boop = FactoryBot.create(:boop)
      expect(Boop).to receive(:random).and_return(boop)

      get "/api/v1/boops/random", headers: headers

      expect(response.status).to eq 200
      expect(response.parsed_body["id"]).to eq(boop.id)
    end
  end
end
