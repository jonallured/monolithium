require "rails_helper"

describe "Admin edits FinancialAccount" do
  include_context "admin password matches"

  scenario "from show page" do
    financial_account = FactoryBot.create(:financial_account)
    visit "/admin/financial_accounts/#{financial_account.id}"
    click_on "Edit Financial Account"
    expect(page).to have_css "h1", text: "Edit Financial Account #{financial_account.id}"
    expect(page).to have_css "a", text: "Show Financial Account"
    expect(current_path).to eq edit_admin_financial_account_path(financial_account)
  end

  scenario "update with errors" do
    financial_account = FactoryBot.create(:financial_account)
    visit "/admin/financial_accounts/#{financial_account.id}/edit"
    fill_in "name", with: ""
    click_on "update"
    expect(page).to have_css ".border-pink p", text: "Name can't be blank"
  end

  scenario "update successfully" do
    financial_account = FactoryBot.create(
      :financial_account,
      name: "Band new account"
    )
    visit "/admin/financial_accounts/#{financial_account.id}/edit"
    fill_in "name", with: "Brand new account"
    click_on "update"
    expect(page).to have_css ".border-purple p", text: "Financial Account successfully updated"
    financial_account.reload
    expect(financial_account.name).to eq "Brand new account"
  end
end
