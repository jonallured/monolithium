require "rails_helper"

describe "PATCH /api/v1/financial_statements/:id" do
  let(:headers) { {ApiController::CLIENT_TOKEN_HEADER => Monolithium.config.client_token} }
  let(:account) { FactoryBot.create(:financial_account) }

  let(:statement) do
    FactoryBot.create(
      :financial_statement,
      ending_amount_cents: 70_00,
      financial_account: account,
      period_start_on: "2024-06-01",
      starting_amount_cents: 100_00
    )
  end

  context "without a client token" do
    it "returns a bare 404" do
      patch "/api/v1/financial_statements/#{statement.id}", params: {financial_statement: {ending_amount_cents: 1}}

      expect(response.status).to eq 404
      expect(response.body).to be_empty
    end

    it "doesn't change the statement" do
      patch "/api/v1/financial_statements/#{statement.id}", params: {financial_statement: {ending_amount_cents: 1}}

      expect(statement.reload.ending_amount_cents).to eq 70_00
    end
  end

  context "with an unknown id" do
    it "returns 404 and an error message" do
      patch "/api/v1/financial_statements/0", params: {financial_statement: {ending_amount_cents: 1}}, headers: headers

      expect(response.status).to eq 404
      expect(response.parsed_body["error"]).to match "Couldn't find FinancialStatement"
    end
  end

  context "without required param" do
    it "returns 400 and an error message" do
      patch "/api/v1/financial_statements/#{statement.id}", params: {}, headers: headers

      expect(response.status).to eq 400
      expect(response.parsed_body["error"]).to match "param is missing"
    end
  end

  context "with a period_start_on that isn't the first of a month" do
    it "returns 422 and an error message" do
      patch "/api/v1/financial_statements/#{statement.id}", params: {financial_statement: {period_start_on: "2024-06-15"}}, headers: headers

      expect(response.status).to eq 422
      expect(response.parsed_body["error"]).to eq "Validation failed: Period start on must be the first of a month"
    end
  end

  context "moving to a month the account already has" do
    before do
      FactoryBot.create(:financial_statement, financial_account: account, period_start_on: "2024-07-01")
    end

    it "returns 422 and an error message" do
      patch "/api/v1/financial_statements/#{statement.id}", params: {financial_statement: {period_start_on: "2024-07-01"}}, headers: headers

      expect(response.status).to eq 422
      expect(response.parsed_body["error"]).to eq "Validation failed: Period start on has already been taken"
    end
  end

  context "with a valid update" do
    it "returns 200 and the updated json" do
      patch "/api/v1/financial_statements/#{statement.id}", params: {financial_statement: {ending_amount_cents: 80_00}}, headers: headers

      expect(response.status).to eq 200
      expect(response.parsed_body).to include("ending_amount_cents" => 80_00, "net_amount_cents" => -20_00)
    end
  end

  context "with a financial_account_id" do
    let(:other_account) { FactoryBot.create(:financial_account) }

    it "doesn't move the statement to another account" do
      patch "/api/v1/financial_statements/#{statement.id}", params: {financial_statement: {financial_account_id: other_account.id}}, headers: headers

      expect(statement.reload.financial_account).to eq account
    end
  end
end
