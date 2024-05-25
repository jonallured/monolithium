require "rails_helper"

describe "Admin views sneakers" do
  include_context "admin password matches"

  scenario "from dashboard" do
    visit "/dashboard"
    click_on "Sneakers"
    expect(page).to have_css "h1", text: "Sneakers"
    expect(page).to have_current_path crud_sneakers_path
  end

  scenario "with no records" do
    visit "/crud/sneakers"
    expect(page.all("tbody tr").count).to eq 0
  end

  scenario "with a page of records" do
    FactoryBot.create_list(:sneaker, 3)
    visit "/crud/sneakers"
    expect(page.all("tbody tr").count).to eq 3
    expect(page).to_not have_css "nav.pagination"
  end

  scenario "with two pages of records" do
    FactoryBot.create_list(:sneaker, 4)
    visit "/crud/sneakers"
    expect(page.all("tbody tr").count).to eq 3
    expect(page).to have_css "nav.pagination"
  end
end
