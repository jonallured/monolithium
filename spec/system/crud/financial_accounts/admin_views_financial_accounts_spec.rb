require "rails_helper"

describe "Admin views financial accounts" do
  include_context "admin password matches"

  scenario "from dashboard" do
    visit "/dashboard"
    click_on "Financial Accounts"
    expect(page).to have_css "h1", text: "Financial Accounts"
    expect(current_path).to eq crud_financial_accounts_path
  end

  scenario "with no records" do
    visit "/crud/financial_accounts"
    expect(page.all("tbody tr").count).to eq 0
  end

  scenario "with a page of records" do
    FactoryBot.create_list(:financial_account, 3)
    visit "/crud/financial_accounts"
    expect(page.all("tbody tr").count).to eq 3
    expect(page).to_not have_css "nav.pagination"
  end

  scenario "with two pages of records" do
    FactoryBot.create_list(:financial_account, 4)
    visit "/crud/financial_accounts"
    expect(page.all("tbody tr").count).to eq 3
    expect(page).to have_css "nav.pagination"
  end
end
