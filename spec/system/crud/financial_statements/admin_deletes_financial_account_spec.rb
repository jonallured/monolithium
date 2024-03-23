require "rails_helper"

describe "Admin deletes financial statement" do
  include_context "admin password matches"

  let(:financial_account) { FactoryBot.create(:financial_account) }
  let(:financial_statement) do
    FactoryBot.create(:financial_statement, financial_account: financial_account)
  end

  scenario "cancels delete" do
    visit "/crud/financial_accounts/#{financial_account.id}/financial_statements/#{financial_statement.id}"

    dismiss_confirm { click_on "Delete Financial Statement" }

    expect(FinancialStatement.count).to eq 1
    expect(page).to have_current_path crud_financial_account_financial_statement_path(financial_account, financial_statement)
  end

  scenario "confirms delete" do
    visit "/crud/financial_accounts/#{financial_account.id}/financial_statements/#{financial_statement.id}"

    accept_confirm { click_on "Delete Financial Statement" }

    expect(page).to have_css ".notice", text: "Financial Statement deleted"

    expect(FinancialStatement.count).to eq 0
    expect(page).to have_current_path crud_financial_account_financial_statements_path(financial_account)
  end
end
