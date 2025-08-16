require "rails_helper"

describe "Admin edits thing" do
  include_context "admin password matches"

  scenario "from show page" do
    thing = FactoryBot.create(:thing)
    visit "/crud/things/#{thing.id}"
    click_on "Edit Thing"
    expect(page).to have_css "h1", text: "Edit Thing #{thing.id}"
    expect(page).to have_css "a", text: "Show Thing"
    expect(page).to have_current_path edit_crud_thing_path(thing)
  end

  scenario "edit with errors" do
    thing = FactoryBot.create(:thing)
    visit "/crud/things/#{thing.id}/edit"
    fill_in "REPLACE_ME", with: ""
    click_on "update"
    expect(page).to have_css ".alert", text: "REPLACE_ME"
  end

  scenario "edit successfully" do
    thing = FactoryBot.create(
      :thing,
      REPLACE_ME: "REPLACE_ME"
    )
    visit "/crud/things/#{thing.id}/edit"
    fill_in "REPLACE_ME", with: "REPLACE_ME"
    click_on "update"

    expect(page).to have_css ".notice", text: "Thing updated"
    expect(page).to have_current_path crud_thing_path(thing)
    expect(page).to have_css "td", text: "REPLACE_ME"
  end
end
