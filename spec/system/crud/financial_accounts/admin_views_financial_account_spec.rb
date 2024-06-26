require "rails_helper"

describe "Admin views financial account" do
  include_context "admin password matches"

  scenario "from list page" do
    financial_account = FactoryBot.create(:financial_account)
    visit "/crud/financial_accounts"
    click_on financial_account.id.to_s
    expect(page).to have_css "h1", text: "Financial Account #{financial_account.id}"
    expect(page).to have_css "a", text: "Financial Account List"
    expect(page).to have_current_path crud_financial_account_path(financial_account)
  end

  scenario "from financial statements page" do
    financial_account = FactoryBot.create(:financial_account)
    visit "/crud/financial_accounts/#{financial_account.id}/financial_statements"
    click_on "Financial Account"
    expect(page).to have_css "h1", text: "Financial Account #{financial_account.id}"
    expect(page).to have_current_path crud_financial_account_path(financial_account)
  end

  scenario "viewing a record" do
    financial_account = FactoryBot.create(
      :financial_account,
      name: "Slush fund"
    )

    visit "/crud/financial_accounts/#{financial_account.id}"

    actual_values = page.all("tr").map do |table_row|
      table_row.all("td").map(&:text)
    end

    expect(actual_values).to eq(
      [
        ["Name", "Slush fund"],
        ["Category", "checking"],
        ["Created At", financial_account.created_at.to_fs],
        ["Updated At", financial_account.updated_at.to_fs]
      ]
    )
  end

  scenario "views random record" do
    financial_account = FactoryBot.create(:financial_account)
    expect(FinancialAccount).to receive(:random).and_return(financial_account)

    visit "/crud/financial_accounts"
    click_on "Random Financial Account"

    expect(page).to have_css "h1", text: "Financial Account #{financial_account.id}"
    expect(page).to have_current_path crud_financial_account_path(financial_account)
  end
end
