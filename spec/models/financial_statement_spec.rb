require "rails_helper"

describe FinancialStatement do
  describe "validation" do
    context "without required associations" do
      it "is invalid" do
        financial_statement = FinancialStatement.new
        expect(financial_statement).to_not be_valid
      end
    end

    context "without required attrs" do
      it "is invalid" do
        financial_account = FactoryBot.create(:financial_account)
        financial_statement = FinancialStatement.new(
          financial_account: financial_account
        )
        expect(financial_statement).to_not be_valid
      end
    end

    context "with required attrs" do
      it "is valid" do
        financial_account = FactoryBot.create(:financial_account)
        financial_statement = FinancialStatement.new(
          financial_account: financial_account,
          period_start_on: Date.today,
          starting_amount_cents: 1_000,
          ending_amount_cents: 2_000
        )
        expect(financial_statement).to be_valid
      end
    end

    context "with a duplicate period_start_on for same account" do
      it "is invalid" do
        financial_account = FactoryBot.create(:financial_account)
        period_start_on = Date.today
        FinancialStatement.create(
          financial_account: financial_account,
          period_start_on: period_start_on,
          starting_amount_cents: 1_000,
          ending_amount_cents: 2_000
        )
        dupe = FinancialStatement.new(
          financial_account: financial_account,
          period_start_on: period_start_on,
          starting_amount_cents: 1_000,
          ending_amount_cents: 2_000
        )
        expect(dupe).to_not be_valid
      end
    end
  end

  describe "scopes" do
    describe "for_year" do
      let(:period_start_on) { Date.today }

      let!(:financial_statement) do
        FactoryBot.create(
          :financial_statement,
          period_start_on: period_start_on
        )
      end

      context "with year as nil" do
        let(:year) { nil }

        it "returns an empty array" do
          expect(FinancialStatement.for_year(year)).to eq []
        end
      end

      context "with year that has no matches" do
        let(:year) { period_start_on.year - 1 }

        it "returns an empty array" do
          expect(FinancialStatement.for_year(year)).to eq []
        end
      end

      context "with year that has a match" do
        let(:year) { period_start_on.year }

        it "returns that match" do
          expect(FinancialStatement.for_year(year)).to eq [financial_statement]
        end
      end
    end
  end
end
