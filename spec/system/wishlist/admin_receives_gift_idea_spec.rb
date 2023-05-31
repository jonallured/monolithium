require "rails_helper"

describe "Admin receives gift idea" do
  include_context "admin password matches"

  scenario "with available gift idea" do
    gift_idea = FactoryBot.create(:available_gift_idea)
    visit "/wishlist"
    click_on "receive"

    expect(page).to have_button "undo"
    expect(page).to_not have_button "receive"

    gift_idea.reload
    expect(gift_idea.received_at).to_not be_nil
  end
end
