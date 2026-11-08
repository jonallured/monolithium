require "rails_helper"

describe "GET /api/v1/financial_statements" do
  let(:headers) { {ApiController::CLIENT_TOKEN_HEADER => Monolithium.config.client_token} }
  let(:account) { FactoryBot.create(:financial_account) }

  context "without a client token" do
    it "returns a 404" do
      get "/api/v1/financial_statements"

      expect(response.status).to eq 404
    end
  end

  context "with no records" do
    it "returns an empty array and a zero total" do
      get "/api/v1/financial_statements", headers: headers

      expect(response.status).to eq 200
      expect(response.parsed_body).to eq([])
      expect(response.headers["x-total-count"]).to eq "0"
    end
  end

  context "with a record" do
    it "returns the json for that record" do
      statement = FactoryBot.create(
        :financial_statement,
        ending_amount_cents: 70,
        financial_account: account,
        period_start_on: "2024-01-01",
        starting_amount_cents: 100
      )

      get "/api/v1/financial_statements", headers: headers

      expect(response.status).to eq 200
      expect(response.parsed_body.first).to match({
        "created_at" => anything,
        "ending_amount_cents" => 70,
        "financial_account_id" => account.id,
        "id" => statement.id,
        "net_amount_cents" => -30,
        "period_start_on" => "2024-01-01",
        "starting_amount_cents" => 100,
        "updated_at" => anything
      })
    end
  end

  context "with a financial_account_id param" do
    it "returns only that account's statements" do
      statement = FactoryBot.create(:financial_statement, financial_account: account)
      FactoryBot.create(:financial_statement)

      get "/api/v1/financial_statements", params: {financial_account_id: account.id}, headers: headers

      actual_ids = response.parsed_body.map { |statement_json| statement_json["id"] }
      expect(actual_ids).to eq([statement.id])
    end
  end

  context "with a financial_account_id that matches no account" do
    it "returns an empty array" do
      FactoryBot.create(:financial_statement)

      get "/api/v1/financial_statements", params: {financial_account_id: 999_999}, headers: headers

      expect(response.parsed_body).to eq([])
    end
  end

  context "with a period_start_on param" do
    it "returns only statements in that period" do
      FactoryBot.create(:financial_statement, financial_account: account, period_start_on: "2023-12-01")
      statement = FactoryBot.create(:financial_statement, financial_account: account, period_start_on: "2024-01-01")

      get "/api/v1/financial_statements", params: {period_start_on: "2024"}, headers: headers

      actual_ids = response.parsed_body.map { |statement_json| statement_json["id"] }
      expect(actual_ids).to eq([statement.id])
    end
  end

  context "with a few statements" do
    it "returns them with the newest period first" do
      oldest = FactoryBot.create(:financial_statement, financial_account: account, period_start_on: "2024-01-01")
      newest = FactoryBot.create(:financial_statement, financial_account: account, period_start_on: "2024-03-01")
      middle = FactoryBot.create(:financial_statement, financial_account: account, period_start_on: "2024-02-01")

      get "/api/v1/financial_statements", headers: headers

      actual_ids = response.parsed_body.map { |statement_json| statement_json["id"] }
      expect(actual_ids).to eq([newest.id, middle.id, oldest.id])
    end
  end

  context "with a sort param" do
    it "returns them in that order" do
      newest = FactoryBot.create(:financial_statement, financial_account: account, period_start_on: "2024-03-01")
      oldest = FactoryBot.create(:financial_statement, financial_account: account, period_start_on: "2024-01-01")

      get "/api/v1/financial_statements", params: {sort: "period_start_on"}, headers: headers

      actual_ids = response.parsed_body.map { |statement_json| statement_json["id"] }
      expect(actual_ids).to eq([oldest.id, newest.id])
    end
  end

  context "with two pages of records" do
    let!(:oldest) { FactoryBot.create(:financial_statement, financial_account: account, period_start_on: "2023-12-01") }

    before do
      FactoryBot.create(:financial_statement, financial_account: account, period_start_on: "2024-01-01")
      FactoryBot.create(:financial_statement, financial_account: account, period_start_on: "2024-02-01")
      FactoryBot.create(:financial_statement, financial_account: account, period_start_on: "2024-03-01")
    end

    it "returns records for page two" do
      get "/api/v1/financial_statements", params: {page: 2}, headers: headers

      expect(response.parsed_body.first["id"]).to eq oldest.id
    end

    it "leaves out the next page header on the last page" do
      get "/api/v1/financial_statements", params: {page: 2}, headers: headers

      expect(response.headers.key?("x-next-page")).to eq false
    end
  end

  context "with an invalid period_start_on param" do
    it "returns a 400 and error message" do
      get "/api/v1/financial_statements", params: {period_start_on: "soon"}, headers: headers

      expect(response.status).to eq 400
      expect(response.parsed_body["error"]).to eq "period_start_on must be YYYY, YYYY-MM or YYYY-MM-DD"
    end
  end

  context "with an unsupported param" do
    it "returns a 400 and error message" do
      get "/api/v1/financial_statements", params: {account: account.id}, headers: headers

      expect(response.status).to eq 400
      expect(response.parsed_body["error"]).to eq "unsupported params: account"
    end
  end
end
