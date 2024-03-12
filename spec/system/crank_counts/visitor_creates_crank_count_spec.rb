require "rails_helper"

describe "visitor creates crank count" do
  scenario "create successfully" do
    crank_user = FactoryBot.create(:crank_user)
    visit "/crank_users/#{crank_user.code}/crank_counts/new?ticks=77"
    click_on "create"
    expect(page).to have_content "Crank Count created"
    crank_count = CrankCount.last
    expect(page).to have_content crank_user.code
    expect(page.current_path).to eq crank_user_crank_count_path(crank_user, crank_count)
    expect(page).to have_content "77 ticks"
  end
end
