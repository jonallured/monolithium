require "rails_helper"

describe FinancialTransaction do
  describe "validation" do
    context "without required associations" do
      it "is invalid" do
        financial_transaction = FinancialTransaction.new
        expect(financial_transaction).to_not be_valid
      end
    end

    context "without required attrs" do
      it "is invalid" do
        financial_account = FactoryBot.create(:financial_account)
        financial_transaction = FinancialTransaction.new(
          financial_account: financial_account
        )
        expect(financial_transaction).to_not be_valid
      end
    end

    context "with required attrs" do
      it "is valid" do
        financial_account = FactoryBot.create(:financial_account)
        financial_transaction = FinancialTransaction.new(
          financial_account: financial_account,
          posted_on: Date.today,
          amount_cents: 444,
          description: "Young Chicken"
        )
        expect(financial_transaction).to be_valid
      end
    end
  end
end
