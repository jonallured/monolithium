require "rails_helper"

describe "POST /api/v1/financial_accounts" do
  let(:headers) { {ApiController::CLIENT_TOKEN_HEADER => Monolithium.config.client_token} }
  let(:attrs) { {category: "savings", name: "Boat Money"} }

  context "without a client token" do
    it "returns a bare 404" do
      post "/api/v1/financial_accounts", params: {financial_account: attrs}

      expect(response.status).to eq 404
      expect(response.body).to be_empty
    end

    it "doesn't create an account" do
      expect {
        post "/api/v1/financial_accounts", params: {financial_account: attrs}
      }.to_not change(FinancialAccount, :count)
    end
  end

  context "without required param" do
    it "returns 400 and an error message" do
      post "/api/v1/financial_accounts", params: {}, headers: headers

      expect(response.status).to eq 400
      expect(response.parsed_body["error"]).to match "param is missing"
    end
  end

  context "without a name" do
    it "returns 422 and an error message" do
      post "/api/v1/financial_accounts", params: {financial_account: attrs.except(:name)}, headers: headers

      expect(response.status).to eq 422
      expect(response.parsed_body["error"]).to eq "Validation failed: Name can't be blank"
    end
  end

  context "with an unknown category" do
    it "returns 422 and an error message" do
      post "/api/v1/financial_accounts", params: {financial_account: attrs.merge(category: "piggy_bank")}, headers: headers

      expect(response.status).to eq 422
      expect(response.parsed_body["error"]).to eq "Validation failed: Category is not included in the list"
    end
  end

  context "with a name another account has" do
    before { FactoryBot.create(:financial_account, name: "Boat Money") }

    it "returns 422 and an error message" do
      post "/api/v1/financial_accounts", params: {financial_account: attrs}, headers: headers

      expect(response.status).to eq 422
      expect(response.parsed_body["error"]).to eq "Validation failed: Name has already been taken"
    end

    it "doesn't create a second account" do
      expect {
        post "/api/v1/financial_accounts", params: {financial_account: attrs}, headers: headers
      }.to_not change(FinancialAccount, :count)
    end
  end

  context "with valid attributes" do
    it "returns 201 and the json for the account" do
      post "/api/v1/financial_accounts", params: {financial_account: attrs}, headers: headers

      expect(response.status).to eq 201
      expect(response.parsed_body).to match({
        "category" => "savings",
        "closed_on" => nil,
        "created_at" => anything,
        "id" => anything,
        "name" => "Boat Money",
        "updated_at" => anything
      })
    end
  end

  context "with a closed_on date" do
    it "creates a closed account" do
      post "/api/v1/financial_accounts", params: {financial_account: attrs.merge(closed_on: "2019-04-30")}, headers: headers

      expect(response.parsed_body["closed_on"]).to eq "2019-04-30"
    end
  end

  context "with a flat json body" do
    it "creates the account" do
      post "/api/v1/financial_accounts", params: attrs.to_json, headers: headers.merge("CONTENT_TYPE" => "application/json")

      expect(response.status).to eq 201
      expect(FinancialAccount.last.name).to eq "Boat Money"
    end
  end

  context "with bonus attribute" do
    let(:zero_time) { Time.at(0).utc }

    it "ignores bonus attributes" do
      post "/api/v1/financial_accounts", params: {financial_account: attrs.merge(created_at: zero_time)}, headers: headers

      expect(response.status).to eq 201
      expect(response.parsed_body["created_at"]).to_not eq zero_time.as_json
    end
  end
end
