require "rails_helper"

describe "GET /api/v1/gift_ideas/:id" do
  let(:headers) { {ApiController::CLIENT_TOKEN_HEADER => Monolithium.config.client_token} }

  context "with invalid id" do
    it "returns 404" do
      get "/api/v1/gift_ideas/invalid", headers: headers

      expect(response.status).to eq 404
      expect(response.body).to match "Couldn't find GiftIdea"
    end
  end

  context "with a valid id" do
    it "returns the json for that record" do
      gift_idea = FactoryBot.create(
        :gift_idea,
        note: "Please get me the actual physical game, thanks!",
        title: "New Mario Game",
        website_url: "https://www.nintendo.com/new-mario-game"
      )

      get "/api/v1/gift_ideas/#{gift_idea.id}", headers: headers

      expect(response.status).to eq 200
      expect(response.parsed_body).to match({
        "created_at" => anything,
        "id" => gift_idea.id,
        "note" => "Please get me the actual physical game, thanks!",
        "website_url" => "https://www.nintendo.com/new-mario-game",
        "title" => "New Mario Game",
        "updated_at" => anything
      })
    end
  end

  context "with random id" do
    it "returns a random record" do
      gift_idea = FactoryBot.create(:gift_idea)
      expect(GiftIdea).to receive(:random).and_return(gift_idea)

      get "/api/v1/gift_ideas/random", headers: headers

      expect(response.status).to eq 200
      expect(response.parsed_body["id"]).to eq(gift_idea.id)
    end
  end
end
