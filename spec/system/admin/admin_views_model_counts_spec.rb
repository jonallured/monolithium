require "rails_helper"

describe "Admin views model counts" do
  include_context "admin password matches"

  scenario "with no models" do
    visit "/admin/model_counts"

    actual_rows = page.all("tbody tr").map(&:text)

    expected_rows = [
      "Artwork 0",
      "Book 0",
      "GiftIdea 0",
      "Hook 0",
      "Killswitch 0",
      "Lineup 0",
      "LineupArtwork 0",
      "PostBinRequest 0",
      "Project 0",
      "RawHook 0",
      "WebhookSender 0"
    ]

    expect(actual_rows).to match_array(expected_rows)
  end

  scenario "with some models" do
    FactoryBot.create(:book)
    FactoryBot.create(:gift_idea)
    FactoryBot.create(:killswitch)
    FactoryBot.create(:post_bin_request)
    FactoryBot.create(:project)

    lineup = FactoryBot.create(:lineup)

    FactoryBot.create(
      :lineup_artwork,
      artwork: FactoryBot.create(:artwork),
      lineup: lineup
    )

    FactoryBot.create(
      :hook,
      raw_hook: FactoryBot.create(:raw_hook),
      webhook_sender: FactoryBot.create(:webhook_sender)
    )

    visit "/admin/model_counts"

    actual_rows = page.all("tbody tr").map(&:text)

    expected_rows = [
      "Artwork 1",
      "Book 1",
      "GiftIdea 1",
      "Hook 1",
      "Killswitch 1",
      "Lineup 1",
      "LineupArtwork 1",
      "PostBinRequest 1",
      "Project 1",
      "RawHook 1",
      "WebhookSender 1"
    ]

    expect(actual_rows).to match_array(expected_rows)

    expect(page.find("tfoot tr").text).to eq "Total 11"
  end
end
