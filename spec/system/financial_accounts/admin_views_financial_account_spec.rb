require "rails_helper"

describe "Admin views FinancialAccount" do
  include_context "admin password matches"

  scenario "from list page" do
    financial_account = FactoryBot.create(:financial_account)
    visit "/admin/financial_accounts"
    click_on financial_account.id.to_s
    expect(page).to have_css "h1", text: "Financial Account #{financial_account.id}"
    expect(page).to have_css "a", text: "Financial Account List"
    expect(current_path).to eq admin_financial_account_path(financial_account)
  end

  scenario "viewing FinancialAccount" do
    financial_account = FactoryBot.create(
      :financial_account,
      name: "Slush fund"
    )

    visit "/admin/financial_accounts/#{financial_account.id}"

    actual_values = page.all("tr").map do |table_row|
      table_row.all("td").map(&:text)
    end

    expect(actual_values).to eq(
      [
        ["Name", "Slush fund"],
        ["Created At", financial_account.created_at.to_formatted_s(:long)],
        ["Updated At", financial_account.updated_at.to_formatted_s(:long)]
      ]
    )
  end
end
