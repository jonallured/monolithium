require "rails_helper"

describe WellsFargoParser do
  describe ".parse" do
    let!(:wf_checking) { FactoryBot.create(:wf_checking) }
    let(:csv_upload) { FactoryBot.create(:csv_upload, data: data) }

    context "with nil parsed data" do
      let(:data) { '"invalid' }

      it "exits early" do
        expect do
          WellsFargoParser.parse(csv_upload)
        end.to_not raise_error
      end
    end

    context "with a properly formatted transaction" do
      let(:data) { "12/29/2023,-0.89,,,random fee" }

      it "creates a transaction for the Wells Fargo Checking account" do
        WellsFargoParser.parse(csv_upload)
        expect(wf_checking.financial_transactions.count).to eq 1

        financial_transaction = wf_checking.financial_transactions.last
        expect(financial_transaction.amount_cents).to eq(-89)
        expect(financial_transaction.description).to eq "random fee"
        expect(financial_transaction.posted_on).to eq Date.parse("2023-12-29")
      end
    end

    context "with a few transactions" do
      let(:data) do
        <<~EOL
          12/01/2023,100.00,ignore,,check deposit
          12/07/2023,-77.77,,ignore,groceries
          12/29/2023,-0.89,,,random fee
        EOL
      end

      it "creates those transactions on the Wells Fargo Checking account" do
        WellsFargoParser.parse(csv_upload)

        ordered_transactions = wf_checking.financial_transactions.order(:posted_on)
        expect(ordered_transactions.count).to eq 3

        amounts = ordered_transactions.pluck(:amount_cents)
        expect(amounts).to eq [100_00, -77_77, -89]

        dates = ordered_transactions.pluck(:posted_on)
        expect(dates.map(&:to_s)).to eq ["2023-12-01", "2023-12-07", "2023-12-29"]

        descriptions = ordered_transactions.pluck(:description)
        expect(descriptions).to eq [
          "check deposit",
          "groceries",
          "random fee"
        ]
      end
    end
  end
end
