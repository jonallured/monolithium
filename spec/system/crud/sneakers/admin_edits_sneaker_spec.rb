require "rails_helper"

describe "Admin edits sneaker" do
  include_context "admin password matches"

  scenario "from show page" do
    sneaker = FactoryBot.create(:sneaker)
    visit "/crud/sneakers/#{sneaker.id}"
    click_on "Edit Sneaker"
    expect(page).to have_css "h1", text: "Edit Sneaker #{sneaker.id}"
    expect(page).to have_css "a", text: "Show Sneaker"
    expect(page).to have_current_path edit_crud_sneaker_path(sneaker)
  end

  scenario "edit with errors" do
    sneaker = FactoryBot.create(:sneaker)
    visit "/crud/sneakers/#{sneaker.id}/edit"
    fill_in "name", with: ""
    click_on "update"
    expect(page).to have_css ".alert", text: "Name can't be blank"
  end

  scenario "edit successfully" do
    sneaker = FactoryBot.create(
      :sneaker,
      name: "Air Morce 1"
    )
    visit "/crud/sneakers/#{sneaker.id}/edit"
    fill_in "name", with: "Air Force 1"
    click_on "update"

    expect(page).to have_css ".notice", text: "Sneaker updated"
    expect(page).to have_current_path crud_sneaker_path(sneaker)
    expect(page).to have_css "td", text: "Air Force 1"
  end
end
