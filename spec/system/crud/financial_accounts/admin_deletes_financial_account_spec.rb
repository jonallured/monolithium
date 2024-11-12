require "rails_helper"

describe "Admin deletes financial account" do
  include_context "admin password matches"

  let(:financial_account) { FactoryBot.create(:financial_account) }

  scenario "cancels delete", js: true do
    visit "/crud/financial_accounts/#{financial_account.id}"

    dismiss_confirm { click_on "Delete Financial Account" }

    expect(FinancialAccount.count).to eq 1
    expect(page).to have_current_path crud_financial_account_path(financial_account)
  end

  scenario "confirms delete", js: true do
    visit "/crud/financial_accounts/#{financial_account.id}"

    accept_confirm { click_on "Delete Financial Account" }

    expect(page).to have_css ".notice", text: "Financial Account deleted"

    expect(FinancialAccount.count).to eq 0
    expect(page).to have_current_path crud_financial_accounts_path
  end
end
