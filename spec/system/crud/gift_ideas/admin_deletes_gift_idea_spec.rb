require "rails_helper"

describe "Admin deletes gift idea" do
  include_context "admin password matches"

  let(:gift_idea) { FactoryBot.create(:gift_idea) }

  scenario "cancels delete" do
    visit "/crud/gift_ideas/#{gift_idea.id}"

    dismiss_confirm { click_on "Delete Gift Idea" }

    expect(GiftIdea.count).to eq 1
    expect(page).to have_current_path crud_gift_idea_path(gift_idea)
  end

  scenario "confirms delete" do
    visit "/crud/gift_ideas/#{gift_idea.id}"

    accept_confirm { click_on "Delete Gift Idea" }

    expect(page).to have_css ".notice", text: "Gift Idea deleted"

    expect(GiftIdea.count).to eq 0
    expect(page).to have_current_path crud_gift_ideas_path
  end
end
