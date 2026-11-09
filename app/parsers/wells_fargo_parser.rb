class WellsFargoParser
  class UnexpectedHeaders < StandardError; end

  HEADERS = ["DATE", "DESCRIPTION", "AMOUNT", "CHECK #", "STATUS"]

  def self.parse(csv_upload)
    table = csv_upload.parsed_data
    return unless table

    wf_checking = FinancialAccount.find_by(name: "Wells Fargo Checking")
    return unless wf_checking

    headers, *rows = table
    raise UnexpectedHeaders, "expected #{HEADERS}, got #{headers}" unless headers == HEADERS

    FinancialTransaction.transaction do
      rows.each do |date, description, amount|
        attrs = {
          amount_cents: (amount.to_r * 100).to_i,
          description: description.squish,
          posted_on: Date.strptime(date, "%m/%d/%Y")
        }

        wf_checking.financial_transactions.create!(attrs)
      end
    end
  end
end
