require "rails_helper"

describe IndexQuery do
  def ids_for(model, params)
    IndexQuery.new(model, params).records.map(&:id)
  end

  def error_for(model, params)
    IndexQuery.new(model, params).records
  rescue IndexQuery::InvalidParam => error
    error.message
  end

  describe "unknown params" do
    it "raises naming each one" do
      expect(error_for(FinancialTransaction, {"bogus" => "1", "nope" => "2"})).to eq "unsupported params: bogus, nope"
    end

    it "allows the client token param" do
      expect(ids_for(FinancialTransaction, {ApiController::CLIENT_TOKEN_PARAM.to_s => "anything"})).to eq []
    end
  end

  describe "an id filter" do
    it "returns records matching that id" do
      account = FactoryBot.create(:financial_account)
      transaction = FactoryBot.create(:financial_transaction, financial_account: account)
      FactoryBot.create(:financial_transaction)

      expect(ids_for(FinancialTransaction, {"financial_account_id" => account.id.to_s})).to eq [transaction.id]
    end

    it "raises for a value that isn't a positive integer" do
      expect(error_for(FinancialTransaction, {"financial_account_id" => "abc"})).to eq "financial_account_id must be a positive integer"
    end

    it "raises for an array value" do
      expect(error_for(FinancialTransaction, {"financial_account_id" => ["1"]})).to eq "financial_account_id must be a positive integer"
    end
  end

  describe "a date filter" do
    let!(:end_of_february) { FactoryBot.create(:financial_transaction, posted_on: "2024-02-29") }
    let!(:start_of_march) { FactoryBot.create(:financial_transaction, posted_on: "2024-03-01") }
    let!(:end_of_year) { FactoryBot.create(:financial_transaction, posted_on: "2024-12-31") }
    let!(:next_year) { FactoryBot.create(:financial_transaction, posted_on: "2025-01-01") }

    it "matches the whole year for YYYY" do
      expect(ids_for(FinancialTransaction, {"posted_on" => "2024"})).to eq [end_of_year.id, start_of_march.id, end_of_february.id]
    end

    it "matches the whole month for YYYY-MM" do
      expect(ids_for(FinancialTransaction, {"posted_on" => "2024-02"})).to eq [end_of_february.id]
    end

    it "matches one day for YYYY-MM-DD" do
      expect(ids_for(FinancialTransaction, {"posted_on" => "2024-03-01"})).to eq [start_of_march.id]
    end

    it "raises for a value in another format" do
      expect(error_for(FinancialTransaction, {"posted_on" => "03/01/2024"})).to eq "posted_on must be YYYY, YYYY-MM or YYYY-MM-DD"
    end

    it "raises for an array value" do
      expect(error_for(FinancialTransaction, {"posted_on" => ["2024"]})).to eq "posted_on must be YYYY, YYYY-MM or YYYY-MM-DD"
    end

    it "raises for a month that doesn't exist" do
      expect(error_for(FinancialTransaction, {"posted_on" => "2024-13"})).to eq "posted_on must be a real date"
    end

    it "raises for a day that doesn't exist" do
      expect(error_for(FinancialTransaction, {"posted_on" => "2023-02-29"})).to eq "posted_on must be a real date"
    end
  end

  describe "a list filter" do
    it "returns records with that value" do
      savings = FactoryBot.create(:financial_account, category: "savings")
      FactoryBot.create(:financial_account, category: "checking")

      expect(ids_for(FinancialAccount, {"category" => "savings"})).to eq [savings.id]
    end

    it "raises for a value outside the list" do
      message = "category must be one of: #{FinancialAccount::CATEGORIES.join(", ")}"
      expect(error_for(FinancialAccount, {"category" => "boat"})).to eq message
    end
  end

  describe "sorting" do
    let!(:early) { FactoryBot.create(:financial_transaction, posted_on: "2024-01-01", amount_cents: 300) }
    let!(:late) { FactoryBot.create(:financial_transaction, posted_on: "2024-03-01", amount_cents: 100) }
    let!(:late_twin) { FactoryBot.create(:financial_transaction, posted_on: "2024-03-01", amount_cents: 200) }

    it "uses the model's default sort, breaking ties by id in the same direction" do
      expect(ids_for(FinancialTransaction, {})).to eq [late_twin.id, late.id, early.id]
    end

    it "sorts ascending without a dash" do
      expect(ids_for(FinancialTransaction, {"sort" => "posted_on"})).to eq [early.id, late.id, late_twin.id]
    end

    it "sorts by several fields in order" do
      expect(ids_for(FinancialTransaction, {"sort" => "-posted_on,amount_cents"})).to eq [late.id, late_twin.id, early.id]
    end

    it "raises for a field that isn't allowed" do
      expect(error_for(FinancialTransaction, {"sort" => "description"})).to eq "sort must use: amount_cents, posted_on"
    end

    it "raises for a blank sort" do
      expect(error_for(FinancialTransaction, {"sort" => ""})).to eq "sort can't be blank"
    end
  end

  describe "paging" do
    it "returns the requested page" do
      oldest = FactoryBot.create(:financial_transaction, posted_on: "2023-12-01")
      FactoryBot.create_list(:financial_transaction, 3, posted_on: "2024-01-01")

      expect(ids_for(FinancialTransaction, {"page" => "2"})).to eq [oldest.id]
    end

    it "honors per_page" do
      FactoryBot.create_list(:financial_transaction, 3)

      expect(ids_for(FinancialTransaction, {"per_page" => "2"}).size).to eq 2
    end

    it "raises for a page that isn't a positive integer" do
      expect(error_for(FinancialTransaction, {"page" => "0"})).to eq "page must be a positive integer"
    end

    it "raises for per_page over the max" do
      expect(error_for(FinancialTransaction, {"per_page" => "101"})).to eq "per_page must be at most 100"
    end
  end
end
