require "rails_helper"

describe "Admin views warm fuzzies" do
  include_context "admin password matches"

  scenario "from dashboard" do
    visit "/dashboard"
    click_on "Warm Fuzzies"
    expect(page).to have_css "h1", text: "Warm Fuzzies"
    expect(page).to have_current_path crud_warm_fuzzies_path
  end

  scenario "with no records" do
    visit "/crud/warm_fuzzies"
    expect(page.all("tbody tr").count).to eq 0
  end

  scenario "with a page of records" do
    FactoryBot.create_list(:warm_fuzzy, 3)
    visit "/crud/warm_fuzzies"
    expect(page.all("tbody tr").count).to eq 3
    expect(page).to_not have_css "nav.pagination"
  end

  scenario "with two pages of records" do
    FactoryBot.create_list(:warm_fuzzy, 4)
    visit "/crud/warm_fuzzies"
    expect(page.all("tbody tr").count).to eq 3
    expect(page).to have_css "nav.pagination"
  end
end
