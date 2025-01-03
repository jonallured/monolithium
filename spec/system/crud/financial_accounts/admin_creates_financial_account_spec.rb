require "rails_helper"

describe "Admin creates financial account" do
  include_context "admin password matches"

  scenario "from list page" do
    visit "/crud/financial_accounts"
    click_on "New Financial Account"
    expect(page).to have_css "h1", text: "New Financial Account"
    expect(page).to have_css "a", text: "Financial Account List"
    expect(page).to have_current_path new_crud_financial_account_path
  end

  scenario "create with category error", js: true do
    visit "/crud/financial_accounts/new"
    click_on "create"
    select = page.find("#financial_account_category")
    error_message = select.native.attribute("validationMessage")
    expect(error_message).to eq "Please select an item in the list."
  end

  scenario "create with name error" do
    visit "/crud/financial_accounts/new"
    select "checking", from: "financial_account_category"
    click_on "create"
    expect(page).to have_css ".alert", text: "Name can't be blank"
    expect(page).to have_current_path new_crud_financial_account_path
  end

  scenario "create successfully" do
    visit "/crud/financial_accounts/new"
    select "checking", from: "financial_account_category"
    fill_in "name", with: "Brand new account"
    click_on "create"

    expect(page).to have_css ".notice", text: "Financial Account created"

    financial_account = FinancialAccount.last
    expect(page).to have_current_path crud_financial_account_path(financial_account)

    actual_values = page.all("tr").map do |table_row|
      table_row.all("td").map(&:text)
    end

    expect(actual_values).to eq(
      [
        ["Name", "Brand new account"],
        ["Category", "checking"],
        ["Created At", financial_account.created_at.to_fs],
        ["Updated At", financial_account.updated_at.to_fs]
      ]
    )
  end
end
