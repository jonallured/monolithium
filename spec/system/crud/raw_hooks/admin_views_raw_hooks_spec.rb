require "rails_helper"

describe "Admin views raw hooks" do
  include_context "admin password matches"

  scenario "from dashboard" do
    visit "/dashboard"
    click_on "Raw Hooks"
    expect(page).to have_css "h1", text: "Raw Hooks"
    expect(page).to have_current_path crud_raw_hooks_path
  end

  scenario "with no records" do
    visit "/crud/raw_hooks"
    expect(page.all("tbody tr").count).to eq 0
  end

  scenario "with a page of records" do
    FactoryBot.create_list(:raw_hook, 3)
    visit "/crud/raw_hooks"
    expect(page.all("tbody tr").count).to eq 3
    expect(page).to_not have_css "nav.pagination"
  end

  scenario "with two pages of records" do
    FactoryBot.create_list(:raw_hook, 4)
    visit "/crud/raw_hooks"
    expect(page.all("tbody tr").count).to eq 3
    expect(page).to have_css "nav.pagination"
  end
end
