require "rails_helper"

describe "Admin views chores" do
  include_context "admin password matches"

  scenario "from dashboard" do
    visit "/dashboard"
    click_on "Chores"
    expect(page).to have_css "h1", text: "Chores"
    expect(page).to have_current_path crud_chores_path
  end

  scenario "with no records" do
    visit "/crud/chores"
    expect(page.all("tbody tr").count).to eq 0
  end

  scenario "with a page of records" do
    FactoryBot.create_list(:chore, 3)
    visit "/crud/chores"
    expect(page.all("tbody tr").count).to eq 3
    expect(page).to_not have_css "nav.pagination"
  end

  scenario "with two pages of records" do
    FactoryBot.create_list(:chore, 4)
    visit "/crud/chores"
    expect(page.all("tbody tr").count).to eq 3
    expect(page).to have_css "nav.pagination"
  end
end
