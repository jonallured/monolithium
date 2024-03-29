require "rails_helper"

describe "Admin edits gift idea" do
  include_context "admin password matches"

  scenario "from show page" do
    gift_idea = FactoryBot.create(:gift_idea)
    visit "/crud/gift_ideas/#{gift_idea.id}"
    click_on "Edit Gift Idea"
    expect(page).to have_css "h1", text: "Edit Gift Idea #{gift_idea.id}"
    expect(page).to have_css "a", text: "Show Gift Idea"
    expect(page).to have_current_path edit_crud_gift_idea_path(gift_idea)
  end

  scenario "edit with errors" do
    gift_idea = FactoryBot.create(:gift_idea)
    visit "/crud/gift_ideas/#{gift_idea.id}/edit"
    fill_in "title", with: ""
    click_on "update"
    expect(page).to have_css ".alert", text: "Title can't be blank"
  end

  scenario "edit successfully" do
    gift_idea = FactoryBot.create(
      :gift_idea,
      title: "Mew Nario Game"
    )
    visit "/crud/gift_ideas/#{gift_idea.id}/edit"
    fill_in "title", with: "New Mario Game"
    click_on "update"

    expect(page).to have_css ".notice", text: "Gift Idea updated"
    expect(page).to have_current_path crud_gift_idea_path(gift_idea)
    expect(page).to have_css "td", text: "New Mario Game"
  end
end
