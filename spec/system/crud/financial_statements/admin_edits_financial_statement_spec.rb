require "rails_helper"

describe "Admin edits financial statement" do
  include_context "admin password matches"

  let(:financial_account) { FactoryBot.create(:financial_account) }

  scenario "from show page" do
    financial_statement = FactoryBot.create(:financial_statement, financial_account: financial_account)
    visit "/crud/financial_accounts/#{financial_account.id}/financial_statements/#{financial_statement.id}"
    click_on "Edit Financial Statement"
    expect(page).to have_css "h1", text: "Edit Financial Statement #{financial_statement.id}"
    expect(page).to have_css "a", text: "Show Financial Statement"
    expect(page).to have_current_path edit_crud_financial_account_financial_statement_path(financial_account, financial_statement)
  end

  scenario "edit with errors" do
    financial_statement = FactoryBot.create(:financial_statement, financial_account: financial_account)
    visit "/crud/financial_accounts/#{financial_account.id}/financial_statements/#{financial_statement.id}/edit"
    fill_in "starting amount cents", with: ""
    click_on "update"
    expect(page).to have_css ".alert", text: "Starting amount cents can't be blank"
  end

  scenario "edit successfully" do
    financial_statement = FactoryBot.create(
      :financial_statement,
      financial_account: financial_account,
      starting_amount_cents: 777_78
    )
    visit "/crud/financial_accounts/#{financial_account.id}/financial_statements/#{financial_statement.id}/edit"
    fill_in "starting amount cents", with: "77777"
    click_on "update"

    expect(page).to have_css ".notice", text: "Financial Statement updated"
    expect(page).to have_current_path crud_financial_account_financial_statement_path(financial_account, financial_statement)
    expect(page).to have_css "td", text: "77777"
  end
end
