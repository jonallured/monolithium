require "rails_helper"

describe "Admin views boops" do
  include_context "admin password matches"

  scenario "from dashboard" do
    visit "/dashboard"
    click_on "Boops"
    expect(page).to have_css "h1", text: "Boops"
    expect(page).to have_current_path crud_boops_path
  end

  scenario "with no records" do
    visit "/crud/boops"
    expect(page.all("tbody tr").count).to eq 0
  end

  scenario "with a page of records" do
    FactoryBot.create_list(:boop, 3)
    visit "/crud/boops"
    expect(page.all("tbody tr").count).to eq 3
    expect(page).to_not have_css "nav.pagination"
  end

  scenario "with two pages of records" do
    FactoryBot.create_list(:boop, 4)
    visit "/crud/boops"
    expect(page.all("tbody tr").count).to eq 3
    expect(page).to have_css "nav.pagination"
  end
end
