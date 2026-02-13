require "rails_helper"

describe "Admin edits boop" do
  include_context "admin password matches"

  scenario "from show page" do
    boop = FactoryBot.create(:boop)
    visit "/crud/boops/#{boop.id}"
    click_on "Edit Boop"
    expect(page).to have_css "h1", text: "Edit Boop #{boop.id}"
    expect(page).to have_css "a", text: "Show Boop"
    expect(page).to have_current_path edit_crud_boop_path(boop)
  end

  scenario "edit with errors" do
    boop = FactoryBot.create(:boop)
    visit "/crud/boops/#{boop.id}/edit"
    fill_in "display_type", with: ""
    click_on "update"
    expect(page).to have_css ".alert", text: "Display type is not included in the list"
  end

  scenario "edit successfully" do
    boop = FactoryBot.create(
      :boop,
      display_type: "skull"
    )
    visit "/crud/boops/#{boop.id}/edit"
    fill_in "display_type", with: "smile"
    click_on "update"

    expect(page).to have_css ".notice", text: "Boop updated"
    expect(page).to have_current_path crud_boop_path(boop)
    expect(page).to have_css "td", text: "smile"
  end
end
