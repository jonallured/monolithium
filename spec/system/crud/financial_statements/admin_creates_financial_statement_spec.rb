require "rails_helper"

describe "Admin creates financial statement" do
  include_context "admin password matches"

  let(:financial_account) { FactoryBot.create(:financial_account) }

  scenario "from list page" do
    visit "/crud/financial_accounts/#{financial_account.id}/financial_statements"
    click_on "New Financial Statement"
    expect(page).to have_css "h1", text: "New Financial Statement for #{financial_account.name}"
    expect(page).to have_css "a", text: "Financial Statement List"
    expect(page).to have_current_path new_crud_financial_account_financial_statement_path(financial_account)
  end

  scenario "create with errors" do
    visit "/crud/financial_accounts/#{financial_account.id}/financial_statements/new"
    click_on "create"
    expect(page).to have_css ".alert", text: "Period start on can't be blank, Starting amount cents can't be blank, and Ending amount cents can't be blank"
    expect(page).to have_current_path new_crud_financial_account_financial_statement_path(financial_account)
  end

  scenario "create successfully" do
    visit "/crud/financial_accounts/#{financial_account.id}/financial_statements/new"
    fill_in "period start on", with: "01/01/2000"
    fill_in "starting amount cents", with: "50000"
    fill_in "ending amount cents", with: "70000"
    click_on "create"

    expect(page).to have_css ".notice", text: "Financial Statement created"

    financial_statement = FinancialStatement.last
    expect(page).to have_current_path crud_financial_account_financial_statement_path(financial_account, financial_statement)

    actual_values = page.all("tr").map do |table_row|
      table_row.all("td").map(&:text)
    end

    expect(actual_values).to eq(
      [
        ["Period Start On", financial_statement.period_start_on.to_fs],
        ["Starting Amount Cents", "50000"],
        ["Ending Amount Cents", "70000"],
        ["Created At", financial_statement.created_at.to_fs],
        ["Updated At", financial_statement.updated_at.to_fs]
      ]
    )
  end
end
