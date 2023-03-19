require "rails_helper"

describe "Admin deletes gift idea" do
  include_context "admin password matches"

  scenario "delete gift idea" do
    gift_idea = FactoryBot.create(:gift_idea)
    visit "/admin/gift_ideas/#{gift_idea.id}/edit"
    click_on "delete"
    accept_alert

    expect(page).to have_content "Gift Idea deleted"
  end
end
