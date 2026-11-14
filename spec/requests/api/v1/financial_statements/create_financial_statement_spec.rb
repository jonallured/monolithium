require "rails_helper"

describe "POST /api/v1/financial_statements" do
  let(:headers) { {ApiController::CLIENT_TOKEN_HEADER => Monolithium.config.client_token} }
  let(:account) { FactoryBot.create(:financial_account) }

  let(:attrs) do
    {
      ending_amount_cents: 70_00,
      financial_account_id: account.id,
      period_start_on: "2024-06-01",
      starting_amount_cents: 100_00
    }
  end

  context "without a client token" do
    it "returns a bare 404" do
      post "/api/v1/financial_statements", params: {financial_statement: attrs}

      expect(response.status).to eq 404
      expect(response.body).to be_empty
    end

    it "doesn't create a statement" do
      expect {
        post "/api/v1/financial_statements", params: {financial_statement: attrs}
      }.to_not change(FinancialStatement, :count)
    end
  end

  context "without required param" do
    it "returns 400 and an error message" do
      post "/api/v1/financial_statements", params: {}, headers: headers

      expect(response.status).to eq 400
      expect(response.parsed_body["error"]).to match "param is missing"
    end
  end

  context "without a financial_account_id" do
    it "returns 400 and an error message" do
      post "/api/v1/financial_statements", params: {financial_statement: attrs.except(:financial_account_id)}, headers: headers

      expect(response.status).to eq 400
      expect(response.parsed_body["error"]).to match "financial_account_id"
    end
  end

  context "with an unknown financial_account_id" do
    it "returns 404 and an error message" do
      post "/api/v1/financial_statements", params: {financial_statement: attrs.merge(financial_account_id: 0)}, headers: headers

      expect(response.status).to eq 404
      expect(response.parsed_body["error"]).to match "Couldn't find FinancialAccount"
    end
  end

  context "without required attributes" do
    it "returns 422 and an error message" do
      post "/api/v1/financial_statements", params: {financial_statement: {financial_account_id: account.id}}, headers: headers

      expect(response.status).to eq 422
      expect(response.parsed_body["error"]).to match "Period start on can't be blank"
    end
  end

  context "with a period_start_on that isn't the first of a month" do
    it "returns 422 and an error message" do
      post "/api/v1/financial_statements", params: {financial_statement: attrs.merge(period_start_on: "2024-06-15")}, headers: headers

      expect(response.status).to eq 422
      expect(response.parsed_body["error"]).to eq "Validation failed: Period start on must be the first of a month"
    end
  end

  context "with a month the account already has" do
    before do
      FactoryBot.create(:financial_statement, financial_account: account, period_start_on: "2024-06-01")
    end

    it "returns 422 and an error message" do
      post "/api/v1/financial_statements", params: {financial_statement: attrs}, headers: headers

      expect(response.status).to eq 422
      expect(response.parsed_body["error"]).to eq "Validation failed: Period start on has already been taken"
    end

    it "doesn't create a second statement" do
      expect {
        post "/api/v1/financial_statements", params: {financial_statement: attrs}, headers: headers
      }.to_not change(FinancialStatement, :count)
    end
  end

  context "with valid attributes" do
    it "returns 201 and the json for the statement" do
      post "/api/v1/financial_statements", params: {financial_statement: attrs}, headers: headers

      expect(response.status).to eq 201
      expect(response.parsed_body).to match({
        "created_at" => anything,
        "ending_amount_cents" => 70_00,
        "financial_account_id" => account.id,
        "id" => anything,
        "net_amount_cents" => -30_00,
        "period_start_on" => "2024-06-01",
        "starting_amount_cents" => 100_00,
        "updated_at" => anything
      })
    end
  end

  context "with a flat json body" do
    it "creates the statement" do
      post "/api/v1/financial_statements", params: attrs.to_json, headers: headers.merge("CONTENT_TYPE" => "application/json")

      expect(response.status).to eq 201
      expect(FinancialStatement.last.financial_account).to eq account
    end
  end

  context "with bonus attribute" do
    let(:zero_time) { Time.at(0).utc }

    it "ignores bonus attributes" do
      post "/api/v1/financial_statements", params: {financial_statement: attrs.merge(created_at: zero_time)}, headers: headers

      expect(response.status).to eq 201
      expect(response.parsed_body["created_at"]).to_not eq zero_time.as_json
    end
  end
end
