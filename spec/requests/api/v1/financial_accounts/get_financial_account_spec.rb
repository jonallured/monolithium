require "rails_helper"

describe "GET /api/v1/financial_accounts/:id" do
  let(:headers) { {ApiController::CLIENT_TOKEN_HEADER => Monolithium.config.client_token} }

  context "without a client token" do
    it "returns a 404" do
      account = FactoryBot.create(:financial_account)

      get "/api/v1/financial_accounts/#{account.id}"

      expect(response.status).to eq 404
    end
  end

  context "with an invalid id" do
    it "returns a 404 and error message" do
      get "/api/v1/financial_accounts/invalid", headers: headers

      expect(response.status).to eq 404
      expect(response.body).to match "Couldn't find FinancialAccount"
    end
  end

  context "with a valid id" do
    it "returns the json for that record" do
      account = FactoryBot.create(:financial_account, name: "Boat Money", category: "savings")

      get "/api/v1/financial_accounts/#{account.id}", headers: headers

      expect(response.status).to eq 200
      expect(response.parsed_body).to match({
        "category" => "savings",
        "created_at" => anything,
        "id" => account.id,
        "name" => "Boat Money",
        "updated_at" => anything
      })
    end
  end
end
