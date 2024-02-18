require "rails_helper"

describe "Admin creates FinancialAccount" do
  include_context "admin password matches"

  scenario "from list page" do
    visit "/admin/financial_accounts"
    click_on "New Financial Account"
    expect(page).to have_css "h1", text: "New Financial Account"
    expect(page).to have_css "a", text: "Financial Account List"
    expect(current_path).to eq new_admin_financial_account_path
  end

  scenario "create with errors" do
    visit "/admin/financial_accounts/new"
    click_on "create"
    expect(page).to have_css ".border-pink p", text: "Name can't be blank"
  end

  scenario "create successfully" do
    visit "/admin/financial_accounts/new"
    fill_in "name", with: "Brand new account"
    click_on "create"
    expect(page).to have_css ".border-purple p", text: "Financial Account successfully created"
    expect(FinancialAccount.count).to eq 1
    financial_account = FinancialAccount.last
    expect(financial_account.name).to eq "Brand new account"
  end
end
