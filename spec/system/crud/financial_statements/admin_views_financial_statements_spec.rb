require "rails_helper"

describe "Admin views financial statements" do
  include_context "admin password matches"

  let(:financial_account) { FactoryBot.create(:financial_account) }

  scenario "from financial account" do
    visit "/crud/financial_accounts/#{financial_account.id}"
    click_on "Financial Statement List"
    expect(page).to have_css "h1", text: "Financial Statements for #{financial_account.name}"
    expect(current_path).to eq crud_financial_account_financial_statements_path(financial_account)
  end

  scenario "with no records" do
    visit "/crud/financial_accounts/#{financial_account.id}/financial_statements"
    expect(page.all("tbody tr").count).to eq 0
  end

  scenario "with a page of records" do
    FactoryBot.create_list(:financial_statement, 3, financial_account: financial_account)
    visit "/crud/financial_accounts/#{financial_account.id}/financial_statements"
    expect(page.all("tbody tr").count).to eq 3
    expect(page).to_not have_css "nav.pagination"
  end

  scenario "with two pages of records" do
    FactoryBot.create_list(:financial_statement, 4, financial_account: financial_account)
    visit "/crud/financial_accounts/#{financial_account.id}/financial_statements"
    expect(page.all("tbody tr").count).to eq 3
    expect(page).to have_css "nav.pagination"
  end
end
