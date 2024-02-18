require "rails_helper"

describe "Admin creates gift idea" do
  include_context "admin password matches"

  scenario "create gift idea" do
    visit "/admin/gift_ideas/new"
    fill_in "title", with: "New Mario Game"
    fill_in "website", with: "https://www.nintendo.com/new-mario-game"
    fill_in "note", with: "Please get me the actual physical game, thanks!"
    click_on "create"

    actual_values = page.all("tr").map do |table_row|
      table_row.all("td").map(&:text)
    end

    expect(actual_values).to eq(
      [
        ["Title", "New Mario Game"],
        ["Website URL", "https://www.nintendo.com/new-mario-game"],
        ["Note", "Please get me the actual physical game, thanks!"]
      ]
    )
  end
end
