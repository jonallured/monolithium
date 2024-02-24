require "rails_helper"

describe "Admin creates gift idea" do
  include_context "admin password matches"

  scenario "from list page" do
    visit "/crud/gift_ideas"
    click_on "New Gift Idea"
    expect(page).to have_css "h1", text: "New Gift Idea"
    expect(page).to have_css "a", text: "Gift Idea List"
    expect(page).to have_current_path new_crud_gift_idea_path
  end

  scenario "create with errors" do
    visit "/crud/gift_ideas/new"
    click_on "create"
    expect(page).to have_css ".alert", text: "Title can't be blank and Website url can't be blank"
    expect(page).to have_current_path new_crud_gift_idea_path
  end

  scenario "create successfully" do
    visit "/crud/gift_ideas/new"
    fill_in "title", with: "New Mario Game"
    fill_in "website", with: "https://www.nintendo.com/new-mario-game"
    fill_in "note", with: "Please get me the actual physical game, thanks!"
    click_on "create"

    expect(page).to have_css ".notice", text: "Gift Idea created"

    gift_idea = GiftIdea.last
    expect(page).to have_current_path crud_gift_idea_path(gift_idea)

    actual_values = page.all("tr").map do |table_row|
      table_row.all("td").map(&:text)
    end

    expect(actual_values).to eq(
      [
        ["Title", "New Mario Game"],
        ["Website URL", "https://www.nintendo.com/new-mario-game"],
        ["Note", "Please get me the actual physical game, thanks!"],
        ["Created At", gift_idea.created_at.to_formatted_s(:long)],
        ["Updated At", gift_idea.updated_at.to_formatted_s(:long)]
      ]
    )
  end
end
