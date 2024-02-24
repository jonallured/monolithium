require "rails_helper"

describe "Admin views gift ideas" do
  include_context "admin password matches"

  scenario "from dashboard" do
    visit "/dashboard"
    click_on "Gift Ideas"
    expect(page).to have_css "h1", text: "Gift Ideas"
    expect(current_path).to eq crud_gift_ideas_path
  end

  scenario "with no records" do
    visit "/crud/gift_ideas"
    expect(page.all("tbody tr").count).to eq 0
  end

  scenario "with a page of records" do
    FactoryBot.create_list(:gift_idea, 3)
    visit "/crud/gift_ideas"
    expect(page.all("tbody tr").count).to eq 3
    expect(page).to_not have_css "nav.pagination"
  end

  scenario "with two pages of records" do
    FactoryBot.create_list(:gift_idea, 4)
    visit "/crud/gift_ideas"
    expect(page.all("tbody tr").count).to eq 3
    expect(page).to have_css "nav.pagination"
  end
end
