require "rails_helper"

describe "Admin edits raw hook" do
  include_context "admin password matches"

  scenario "from show page" do
    raw_hook = FactoryBot.create(:raw_hook)
    visit "/crud/raw_hooks/#{raw_hook.id}"
    click_on "Edit Raw Hook"
    expect(page).to have_css "h1", text: "Edit Raw Hook #{raw_hook.id}"
    expect(page).to have_css "a", text: "Show Raw Hook"
    expect(page).to have_current_path edit_crud_raw_hook_path(raw_hook)
  end

  scenario "edit with errors" do
    raw_hook = FactoryBot.create(:raw_hook)
    visit "/crud/raw_hooks/#{raw_hook.id}/edit"
    fill_in "body", with: ""
    click_on "update"
    expect(page).to have_css ".alert", text: "Body can't be blank"
  end

  scenario "edit successfully" do
    raw_hook = FactoryBot.create(
      :raw_hook,
      body: "very lame bayload"
    )
    visit "/crud/raw_hooks/#{raw_hook.id}/edit"
    fill_in "body", with: "very cool payload"
    click_on "update"

    expect(page).to have_css ".notice", text: "Raw Hook updated"
    expect(page).to have_current_path crud_raw_hook_path(raw_hook)
    expect(page).to have_css "pre code", text: "very cool payload"
  end
end
