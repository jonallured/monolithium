require "rails_helper"

describe "Admin updates gift idea" do
  include_context "admin password matches"

  scenario "update gift idea" do
    gift_idea = FactoryBot.create(:gift_idea, title: "Mew Nario Game")
    visit "/admin/gift_ideas/#{gift_idea.id}/edit"
    fill_in "title", with: "New Mario Game"
    click_on "update"

    expect(page).to have_content "New Mario Game"
  end
end
