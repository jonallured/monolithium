require "rails_helper"

describe "Visitor claims gift idea" do
  scenario "with available gift idea" do
    gift_idea = FactoryBot.create(:available_gift_idea)
    visit "/wishlist"
    click_on "claim"

    expect(page).to have_button "undo"
    expect(page).to_not have_button "claim"

    gift_idea.reload
    expect(gift_idea.claimed_at).to_not be_nil
  end
end
