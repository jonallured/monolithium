require "rails_helper"

describe "GET /api/v1/gift_ideas" do
  let(:headers) { {ApiController::CLIENT_TOKEN_HEADER => Monolithium.config.client_token} }
  let(:params) { nil }

  context "with no records" do
    it "returns an empty array" do
      get "/api/v1/gift_ideas", params: params, headers: headers

      expect(response.status).to eq 200
      expect(response.parsed_body).to eq([])
    end
  end

  context "with a record" do
    it "returns the json for that record" do
      gift_idea = FactoryBot.create(
        :gift_idea,
        note: "Please get me the actual physical game, thanks!",
        title: "New Mario Game",
        website_url: "https://www.nintendo.com/new-mario-game"
      )

      get "/api/v1/gift_ideas", params: params, headers: headers

      expect(response.status).to eq 200
      expect(response.parsed_body.first).to match({
        "created_at" => anything,
        "id" => gift_idea.id,
        "note" => "Please get me the actual physical game, thanks!",
        "website_url" => "https://www.nintendo.com/new-mario-game",
        "title" => "New Mario Game",
        "updated_at" => anything
      })
    end
  end

  context "with a page of records" do
    let(:params) { {page: 1} }

    it "returns those records with newest first" do
      oldest_gift_idea = FactoryBot.create(:gift_idea, created_at: 1.month.ago)
      middle_gift_idea = FactoryBot.create(:gift_idea, created_at: 1.week.ago)
      newest_gift_idea = FactoryBot.create(:gift_idea, created_at: 1.day.ago)

      get "/api/v1/gift_ideas", params: params, headers: headers

      expect(response.status).to eq 200
      actual_ids = response.parsed_body.map { |gift_idea_json| gift_idea_json["id"] }
      expect(actual_ids).to eq([
        newest_gift_idea.id,
        middle_gift_idea.id,
        oldest_gift_idea.id
      ])
    end
  end

  context "with two pages of records" do
    let(:params) { {page: 2} }

    it "returns records for page two" do
      oldest_gift_idea = FactoryBot.create(:gift_idea, created_at: 1.month.ago)
      FactoryBot.create_list(:gift_idea, 3, created_at: 1.week.ago)

      get "/api/v1/gift_ideas", params: params, headers: headers

      expect(response.status).to eq 200
      expect(response.parsed_body.first["id"]).to eq oldest_gift_idea.id
    end
  end
end
