require "rails_helper"

describe "GET /api/v1/boops" do
  let(:headers) { {ApiController::CLIENT_TOKEN_HEADER => Monolithium.config.client_token} }
  let(:params) { nil }

  context "with no records" do
    it "returns an empty array" do
      get "/api/v1/boops", params: params, headers: headers

      expect(response.status).to eq 200
      expect(response.parsed_body).to eq([])
    end
  end

  context "with a record" do
    it "returns the json for that record" do
      boop = FactoryBot.create(
        :boop,
        display_type: "skull",
        number: 1
      )

      get "/api/v1/boops", params: params, headers: headers

      expect(response.status).to eq 200
      expect(response.parsed_body.first).to match({
        "created_at" => anything,
        "dismissed_at" => nil,
        "display_type" => "skull",
        "id" => boop.id,
        "number" => 1,
        "updated_at" => anything
      })
    end
  end

  context "with a page of records" do
    let(:params) { {page: 1} }

    it "returns those records with newest first" do
      oldest_boop = FactoryBot.create(:boop, created_at: 1.month.ago)
      middle_boop = FactoryBot.create(:boop, created_at: 1.week.ago)
      newest_boop = FactoryBot.create(:boop, created_at: 1.day.ago)

      get "/api/v1/boops", params: params, headers: headers

      expect(response.status).to eq 200
      actual_ids = response.parsed_body.map { |boop_json| boop_json["id"] }
      expect(actual_ids).to eq([
        newest_boop.id,
        middle_boop.id,
        oldest_boop.id
      ])
    end
  end

  context "with two pages of records" do
    let(:params) { {page: 2} }

    it "returns records for page two" do
      oldest_boop = FactoryBot.create(:boop, created_at: 1.month.ago)
      FactoryBot.create_list(:boop, 3, created_at: 1.week.ago)

      get "/api/v1/boops", params: params, headers: headers

      expect(response.status).to eq 200
      expect(response.parsed_body.first["id"]).to eq oldest_boop.id
    end
  end
end
