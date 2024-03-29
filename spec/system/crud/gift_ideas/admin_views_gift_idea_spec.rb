require "rails_helper"

describe "Admin views gift idea" do
  include_context "admin password matches"

  scenario "from list page" do
    gift_idea = FactoryBot.create(:gift_idea)
    visit "/crud/gift_ideas"
    click_on gift_idea.id.to_s
    expect(page).to have_css "h1", text: "Gift Idea #{gift_idea.id}"
    expect(page).to have_css "a", text: "Gift Idea List"
    expect(page).to have_current_path crud_gift_idea_path(gift_idea)
  end

  scenario "viewing a record" do
    gift_idea = FactoryBot.create(
      :gift_idea,
      title: "New Mario Game",
      website_url: "https://www.nintendo.com/new-mario-game",
      note: "Please get me the actual physical game, thanks!"
    )

    visit "/crud/gift_ideas/#{gift_idea.id}"

    actual_values = page.all("tr").map do |table_row|
      table_row.all("td").map(&:text)
    end

    expect(actual_values).to eq(
      [
        ["Title", "New Mario Game"],
        ["Website URL", "https://www.nintendo.com/new-mario-game"],
        ["Note", "Please get me the actual physical game, thanks!"],
        ["Created At", gift_idea.created_at.to_fs],
        ["Updated At", gift_idea.updated_at.to_fs]
      ]
    )
  end

  scenario "views random record" do
    gift_idea = FactoryBot.create(:gift_idea)
    expect(GiftIdea).to receive(:random).and_return(gift_idea)

    visit "/crud/gift_ideas"
    click_on "Random Gift Idea"

    expect(page).to have_css "h1", text: "Gift Idea #{gift_idea.id}"
    expect(page).to have_current_path crud_gift_idea_path(gift_idea)
  end
end
