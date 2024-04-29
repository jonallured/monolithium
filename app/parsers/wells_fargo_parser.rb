class WellsFargoParser
  def self.parse(csv_upload)
    table = csv_upload.parsed_data
    return unless table

    wf_checking = FinancialAccount.find_by(name: "Wells Fargo Checking")
    return unless wf_checking

    table.each do |row|
      amount_cents = (row[1].to_r * 100).to_i
      posted_on = Date.strptime(row[0], "%m/%d/%Y")

      attrs = {
        amount_cents: amount_cents,
        description: row[4],
        posted_on: posted_on
      }

      wf_checking.financial_transactions.create!(attrs)
    end
  end
end
