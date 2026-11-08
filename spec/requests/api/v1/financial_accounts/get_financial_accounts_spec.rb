require "rails_helper"

describe "GET /api/v1/financial_accounts" do
  let(:headers) { {ApiController::CLIENT_TOKEN_HEADER => Monolithium.config.client_token} }

  context "without a client token" do
    it "returns a 404" do
      get "/api/v1/financial_accounts"

      expect(response.status).to eq 404
    end
  end

  context "with no records" do
    it "returns an empty array" do
      get "/api/v1/financial_accounts", headers: headers

      expect(response.status).to eq 200
      expect(response.parsed_body).to eq([])
    end
  end

  context "with a record" do
    it "returns the json for that record" do
      account = FactoryBot.create(:financial_account, name: "Boat Money", category: "savings")

      get "/api/v1/financial_accounts", headers: headers

      expect(response.status).to eq 200
      expect(response.parsed_body.first).to match({
        "category" => "savings",
        "created_at" => anything,
        "id" => account.id,
        "name" => "Boat Money",
        "updated_at" => anything
      })
    end
  end

  context "with a few accounts" do
    it "returns them ordered by category and then name" do
      savings = FactoryBot.create(:financial_account, category: "savings", name: "Alpha")
      checking_b = FactoryBot.create(:financial_account, category: "checking", name: "Bravo")
      checking_a = FactoryBot.create(:financial_account, category: "checking", name: "Alpha Checking")

      get "/api/v1/financial_accounts", headers: headers

      actual_ids = response.parsed_body.map { |account_json| account_json["id"] }
      expect(actual_ids).to eq([checking_a.id, checking_b.id, savings.id])
    end
  end

  context "with a category param" do
    it "returns only accounts in that category" do
      FactoryBot.create(:financial_account, category: "checking")
      savings = FactoryBot.create(:financial_account, category: "savings")

      get "/api/v1/financial_accounts", params: {category: "savings"}, headers: headers

      actual_ids = response.parsed_body.map { |account_json| account_json["id"] }
      expect(actual_ids).to eq([savings.id])
    end
  end

  context "with an invalid category param" do
    it "returns a 400 and error message" do
      get "/api/v1/financial_accounts", params: {category: "boat"}, headers: headers

      expect(response.status).to eq 400
      expect(response.parsed_body["error"]).to start_with "category must be one of"
    end
  end

  context "with more records than fit on a page" do
    it "returns the total count and next page in headers" do
      FactoryBot.create_list(:financial_account, 4)

      get "/api/v1/financial_accounts", headers: headers

      expect(response.headers.to_h.slice("x-total-count", "x-next-page")).to eq({
        "x-total-count" => "4",
        "x-next-page" => "2"
      })
    end
  end
end
