require "rails_helper"

describe "Admin deletes FinancialAccount" do
  include_context "admin password matches"

  let(:financial_account) { FactoryBot.create(:financial_account) }

  scenario "cancels delete" do
    visit "/admin/financial_accounts/#{financial_account.id}"

    dismiss_confirm { click_on "Delete Financial Account" }

    expect(FinancialAccount.count).to eq 1
    expect(current_path).to eq admin_financial_account_path(financial_account)
  end

  scenario "confirms delete" do
    visit "/admin/financial_accounts/#{financial_account.id}"

    accept_confirm { click_on "Delete Financial Account" }

    expect(page).to have_css "h1", text: "Financial Accounts"

    expect(FinancialAccount.count).to eq 0
    expect(current_path).to eq admin_financial_accounts_path
  end
end
