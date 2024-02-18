require "rails_helper"

describe "Admin views gift idea" do
  include_context "admin password matches"

  scenario "views gift idea" do
    gift_idea = FactoryBot.create(
      :gift_idea,
      title: "New Mario Game",
      website_url: "https://www.nintendo.com/new-mario-game",
      note: "Please get me the actual physical game, thanks!"
    )

    visit "/admin/gift_ideas/#{gift_idea.id}"

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
