require "rails_helper"

describe "Admin edits financial account" do
  include_context "admin password matches"

  scenario "from show page" do
    financial_account = FactoryBot.create(:financial_account)
    visit "/crud/financial_accounts/#{financial_account.id}"
    click_on "Edit Financial Account"
    expect(page).to have_css "h1", text: "Edit Financial Account #{financial_account.id}"
    expect(page).to have_css "a", text: "Show Financial Account"
    expect(current_path).to eq edit_crud_financial_account_path(financial_account)
  end

  scenario "edit with errors" do
    financial_account = FactoryBot.create(:financial_account)
    visit "/crud/financial_accounts/#{financial_account.id}/edit"
    fill_in "name", with: ""
    click_on "update"
    expect(page).to have_css ".alert", text: "Name can't be blank"
  end

  scenario "edit successfully" do
    financial_account = FactoryBot.create(
      :financial_account,
      name: "Band new account"
    )
    visit "/crud/financial_accounts/#{financial_account.id}/edit"
    fill_in "name", with: "Brand new account"
    click_on "update"

    expect(page).to have_css ".notice", text: "Financial Account updated"
    expect(current_path).to eq crud_financial_account_path(financial_account)
    expect(page).to have_css "td", text: "Brand new account"
  end
end
