require "rails_helper"

describe FinancialAccount do
  describe "validation" do
    context "without required attrs" do
      it "is invalid" do
        financial_account = FinancialAccount.new
        expect(financial_account).to_not be_valid
      end
    end

    context "with required attrs" do
      it "is valid" do
        financial_account = FinancialAccount.new(name: "Boat Money", category: "checking")
        expect(financial_account).to be_valid
      end
    end

    context "with a duplicate name" do
      it "is invalid" do
        name = "Boat Money"
        FactoryBot.create(:financial_account, name: name)
        dupe = FactoryBot.build(:financial_account, name: name)
        expect(dupe).to_not be_valid
      end
    end
  end

  describe "destroying" do
    context "with an associated FinancialStatement record" do
      it "destroys that associated record too" do
        financial_account = FactoryBot.create(:financial_account)
        FactoryBot.create(:financial_statement, financial_account: financial_account)

        financial_account.destroy
        expect(FinancialAccount.count).to eq 0
        expect(FinancialStatement.count).to eq 0
      end
    end

    context "with an associated FinancialTransaction record" do
      it "destroys that associated record too" do
        financial_account = FactoryBot.create(:financial_account)
        FactoryBot.create(:financial_transaction, financial_account: financial_account)

        financial_account.destroy
        expect(FinancialAccount.count).to eq 0
        expect(FinancialTransaction.count).to eq 0
      end
    end
  end
end
