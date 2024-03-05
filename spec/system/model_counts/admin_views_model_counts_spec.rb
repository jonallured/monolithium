require "rails_helper"

describe "Admin views model counts" do
  include_context "admin password matches"

  scenario "with no models" do
    visit "/model_counts"

    actual_rows = page.all("tbody tr").map(&:text)

    expected_rows = [
      "Artwork 0",
      "Book 0",
      "CrankUser 0",
      "CsvUpload 0",
      "FinancialAccount 0",
      "FinancialStatement 0",
      "FinancialTransaction 0",
      "GiftIdea 0",
      "Hook 0",
      "Killswitch 0",
      "Lineup 0",
      "LineupArtwork 0",
      "PostBinRequest 0",
      "Project 0",
      "RawHook 0",
      "WebhookSender 0",
      "WorkDay 0"
    ]

    expect(actual_rows).to match_array(expected_rows)
  end

  scenario "with some models" do
    FactoryBot.create(:book)
    FactoryBot.create(:crank_user)
    FactoryBot.create(:csv_upload)
    FactoryBot.create(:gift_idea)
    FactoryBot.create(:killswitch)
    FactoryBot.create(:post_bin_request)
    FactoryBot.create(:project)
    FactoryBot.create(:work_day)

    financial_account = FactoryBot.create(:financial_account)
    FactoryBot.create(:financial_statement, financial_account: financial_account)
    FactoryBot.create(:financial_transaction, financial_account: financial_account)

    FactoryBot.create(
      :hook,
      raw_hook: FactoryBot.create(:raw_hook),
      webhook_sender: FactoryBot.create(:webhook_sender)
    )

    lineup = FactoryBot.create(:lineup)
    FactoryBot.create(
      :lineup_artwork,
      artwork: FactoryBot.create(:artwork),
      lineup: lineup
    )

    visit "/model_counts"

    actual_rows = page.all("tbody tr").map(&:text)

    expected_rows = [
      "Artwork 1",
      "Book 1",
      "CrankUser 1",
      "CsvUpload 1",
      "FinancialAccount 1",
      "FinancialStatement 1",
      "FinancialTransaction 1",
      "GiftIdea 1",
      "Hook 1",
      "Killswitch 1",
      "Lineup 1",
      "LineupArtwork 1",
      "PostBinRequest 1",
      "Project 1",
      "RawHook 1",
      "WebhookSender 1",
      "WorkDay 1"
    ]

    expect(actual_rows).to match_array(expected_rows)

    expect(page.find("tfoot tr").text).to eq "Total 17"
  end
end
