require "rails_helper"

describe "Admin views financial statement" do
  include_context "admin password matches"

  let(:financial_account) { FactoryBot.create(:financial_account) }

  scenario "from list page" do
    financial_statement = FactoryBot.create(:financial_statement, financial_account: financial_account)
    visit "/crud/financial_accounts/#{financial_account.id}/financial_statements"
    click_on financial_statement.id.to_s
    expect(page).to have_css "h1", text: "Financial Statement #{financial_statement.id} for #{financial_account.name}"
    expect(page).to have_css "a", text: "Financial Statement List"
    expect(current_path).to eq crud_financial_account_financial_statement_path(financial_account, financial_statement)
  end

  scenario "viewing a record" do
    financial_statement = FactoryBot.create(
      :financial_statement,
      financial_account: financial_account,
      period_start_on: Date.today,
      starting_amount_cents: 400_00,
      ending_amount_cents: 200_00
    )

    visit "/crud/financial_accounts/#{financial_account.id}/financial_statements/#{financial_statement.id}"

    actual_values = page.all("tr").map do |table_row|
      table_row.all("td").map(&:text)
    end

    expect(actual_values).to eq(
      [
        ["Period Start On", financial_statement.period_start_on.to_fs],
        ["Starting Amount Cents", "40000"],
        ["Ending Amount Cents", "20000"],
        ["Created At", financial_account.created_at.to_fs],
        ["Updated At", financial_account.updated_at.to_fs]
      ]
    )
  end

  scenario "views random record" do
    financial_statement = FactoryBot.create(:financial_statement, financial_account: financial_account)
    expect(FinancialStatement).to receive(:random).and_return(financial_statement)

    visit "/crud/financial_accounts/#{financial_account.id}/financial_statements"
    click_on "Random Financial Statement"

    expect(page).to have_css "h1", text: "Financial Statement #{financial_statement.id} for #{financial_account.name}"
    expect(page).to have_current_path crud_financial_account_financial_statement_path(financial_account, financial_statement)
  end
end
