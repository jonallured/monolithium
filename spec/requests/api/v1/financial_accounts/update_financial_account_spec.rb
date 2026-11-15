require "rails_helper"

describe "PATCH /api/v1/financial_accounts/:id" do
  let(:headers) { {ApiController::CLIENT_TOKEN_HEADER => Monolithium.config.client_token} }
  let(:account) { FactoryBot.create(:financial_account, category: "checking", name: "Boat Money") }

  context "without a client token" do
    it "returns a bare 404" do
      patch "/api/v1/financial_accounts/#{account.id}", params: {financial_account: {name: "Yacht Money"}}

      expect(response.status).to eq 404
      expect(response.body).to be_empty
    end

    it "doesn't change the account" do
      patch "/api/v1/financial_accounts/#{account.id}", params: {financial_account: {name: "Yacht Money"}}

      expect(account.reload.name).to eq "Boat Money"
    end
  end

  context "with an unknown id" do
    it "returns 404 and an error message" do
      patch "/api/v1/financial_accounts/0", params: {financial_account: {name: "Yacht Money"}}, headers: headers

      expect(response.status).to eq 404
      expect(response.parsed_body["error"]).to match "Couldn't find FinancialAccount"
    end
  end

  context "without required param" do
    it "returns 400 and an error message" do
      patch "/api/v1/financial_accounts/#{account.id}", params: {}, headers: headers

      expect(response.status).to eq 400
      expect(response.parsed_body["error"]).to match "param is missing"
    end
  end

  context "with an unknown category" do
    it "returns 422 and an error message" do
      patch "/api/v1/financial_accounts/#{account.id}", params: {financial_account: {category: "piggy_bank"}}, headers: headers

      expect(response.status).to eq 422
      expect(response.parsed_body["error"]).to eq "Validation failed: Category is not included in the list"
    end
  end

  context "renaming to a name another account has" do
    before { FactoryBot.create(:financial_account, name: "Yacht Money") }

    it "returns 422 and an error message" do
      patch "/api/v1/financial_accounts/#{account.id}", params: {financial_account: {name: "Yacht Money"}}, headers: headers

      expect(response.status).to eq 422
      expect(response.parsed_body["error"]).to eq "Validation failed: Name has already been taken"
    end
  end

  context "with a valid update" do
    it "returns 200 and the updated json" do
      patch "/api/v1/financial_accounts/#{account.id}", params: {financial_account: {category: "savings"}}, headers: headers

      expect(response.status).to eq 200
      expect(response.parsed_body).to include("category" => "savings", "name" => "Boat Money")
    end
  end
end
