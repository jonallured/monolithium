require "rails_helper"

describe "GET /api/v1/financial_transactions" do
  let(:headers) { {ApiController::CLIENT_TOKEN_HEADER => Monolithium.config.client_token} }
  let(:account) { FactoryBot.create(:financial_account) }

  context "without a client token" do
    it "returns a 404" do
      get "/api/v1/financial_transactions"

      expect(response.status).to eq 404
    end
  end

  context "with no records" do
    it "returns an empty array" do
      get "/api/v1/financial_transactions", headers: headers

      expect(response.status).to eq 200
      expect(response.parsed_body).to eq([])
    end
  end

  context "with a record" do
    it "returns the json for that record" do
      transaction = FactoryBot.create(
        :financial_transaction,
        amount_cents: -89,
        description: "random fee",
        financial_account: account,
        posted_on: "2023-12-29"
      )

      get "/api/v1/financial_transactions", headers: headers

      expect(response.status).to eq 200
      expect(response.parsed_body.first).to match({
        "amount_cents" => -89,
        "created_at" => anything,
        "description" => "random fee",
        "financial_account_id" => account.id,
        "id" => transaction.id,
        "posted_on" => "2023-12-29",
        "updated_at" => anything
      })
    end
  end

  context "with a financial_account_id param" do
    it "returns only that account's transactions" do
      transaction = FactoryBot.create(:financial_transaction, financial_account: account)
      FactoryBot.create(:financial_transaction)

      get "/api/v1/financial_transactions", params: {financial_account_id: account.id}, headers: headers

      actual_ids = response.parsed_body.map { |transaction_json| transaction_json["id"] }
      expect(actual_ids).to eq([transaction.id])
    end
  end

  context "with a posted_on param" do
    it "returns only transactions in that month" do
      FactoryBot.create(:financial_transaction, posted_on: "2024-02-29")
      transaction = FactoryBot.create(:financial_transaction, posted_on: "2024-03-31")
      FactoryBot.create(:financial_transaction, posted_on: "2024-04-01")

      get "/api/v1/financial_transactions", params: {posted_on: "2024-03"}, headers: headers

      actual_ids = response.parsed_body.map { |transaction_json| transaction_json["id"] }
      expect(actual_ids).to eq([transaction.id])
    end
  end

  context "with a few transactions" do
    it "returns them newest first, breaking ties by newest id" do
      oldest = FactoryBot.create(:financial_transaction, posted_on: "2024-01-01")
      first_same_day = FactoryBot.create(:financial_transaction, posted_on: "2024-02-01")
      second_same_day = FactoryBot.create(:financial_transaction, posted_on: "2024-02-01")

      get "/api/v1/financial_transactions", headers: headers

      actual_ids = response.parsed_body.map { |transaction_json| transaction_json["id"] }
      expect(actual_ids).to eq([second_same_day.id, first_same_day.id, oldest.id])
    end
  end

  context "with a sort param" do
    it "returns them in that order" do
      large = FactoryBot.create(:financial_transaction, amount_cents: 500)
      small = FactoryBot.create(:financial_transaction, amount_cents: -500)

      get "/api/v1/financial_transactions", params: {sort: "amount_cents"}, headers: headers

      actual_ids = response.parsed_body.map { |transaction_json| transaction_json["id"] }
      expect(actual_ids).to eq([small.id, large.id])
    end
  end

  context "with a per_page param" do
    it "returns that many records and the next page" do
      FactoryBot.create_list(:financial_transaction, 3)

      get "/api/v1/financial_transactions", params: {per_page: 2}, headers: headers

      expect(response.parsed_body.size).to eq 2
      expect(response.headers["x-next-page"]).to eq "2"
    end
  end

  context "with an invalid sort param" do
    it "returns a 400 and error message" do
      get "/api/v1/financial_transactions", params: {sort: "description"}, headers: headers

      expect(response.status).to eq 400
      expect(response.parsed_body["error"]).to eq "sort must use: amount_cents, posted_on"
    end
  end

  context "with per_page over the max" do
    it "returns a 400 and error message" do
      get "/api/v1/financial_transactions", params: {per_page: 500}, headers: headers

      expect(response.status).to eq 400
      expect(response.parsed_body["error"]).to eq "per_page must be at most 100"
    end
  end
end
