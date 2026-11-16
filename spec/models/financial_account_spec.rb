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

  describe "closed?" do
    context "without a closed_on date" do
      it "is false" do
        financial_account = FactoryBot.build(:financial_account, closed_on: nil)
        expect(financial_account.closed?).to eq false
      end
    end

    context "with a closed_on date" do
      it "is true" do
        financial_account = FactoryBot.build(:financial_account, closed_on: Date.new(2019, 4, 30))
        expect(financial_account.closed?).to eq true
      end
    end
  end

  describe "open_on?" do
    context "without a closed_on date" do
      it "is true for any date" do
        financial_account = FactoryBot.build(:financial_account, closed_on: nil)
        expect(financial_account.open_on?(Date.new(2030, 1, 1))).to eq true
      end
    end

    context "with a closed_on date" do
      let(:financial_account) { FactoryBot.build(:financial_account, closed_on: Date.new(2019, 4, 30)) }

      it "is true before the close date" do
        expect(financial_account.open_on?(Date.new(2019, 4, 1))).to eq true
      end

      it "is true on the close date" do
        expect(financial_account.open_on?(Date.new(2019, 4, 30))).to eq true
      end

      it "is false after the close date" do
        expect(financial_account.open_on?(Date.new(2019, 5, 1))).to eq false
      end
    end
  end

  describe "scopes" do
    let!(:open_account) { FactoryBot.create(:financial_account, closed_on: nil) }
    let!(:closed_account) { FactoryBot.create(:financial_account, closed_on: Date.new(2019, 4, 30)) }

    it "closed returns only accounts with a closed_on date" do
      expect(FinancialAccount.closed).to eq [closed_account]
    end

    it "not_closed returns only accounts without a closed_on date" do
      expect(FinancialAccount.not_closed).to eq [open_account]
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
