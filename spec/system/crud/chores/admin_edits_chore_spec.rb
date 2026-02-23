require "rails_helper"

describe "Admin edits chore" do
  include_context "admin password matches"

  scenario "from show page" do
    chore = FactoryBot.create(:chore)
    visit "/crud/chores/#{chore.id}"
    click_on "Edit Chore"
    expect(page).to have_css "h1", text: "Edit Chore #{chore.id}"
    expect(page).to have_css "a", text: "Show Chore"
    expect(page).to have_current_path edit_crud_chore_path(chore)
  end

  scenario "edit with errors" do
    chore = FactoryBot.create(:chore)
    visit "/crud/chores/#{chore.id}/edit"
    fill_in "title", with: ""
    click_on "update"
    expect(page).to have_css ".alert", text: "Title can't be blank"
  end

  scenario "edit successfully" do
    chore = FactoryBot.create(
      :chore,
      title: "Cleen Up"
    )
    visit "/crud/chores/#{chore.id}/edit"
    fill_in "title", with: "Clean Up"
    click_on "update"

    expect(page).to have_css ".notice", text: "Chore updated"
    expect(page).to have_current_path crud_chore_path(chore)
    expect(page).to have_css "td", text: "Clean Up"
  end
end
