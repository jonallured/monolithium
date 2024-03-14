require "rails_helper"

describe "Admin edits warm fuzzy" do
  include_context "admin password matches"

  scenario "from show page" do
    warm_fuzzy = FactoryBot.create(:warm_fuzzy)
    visit "/crud/warm_fuzzies/#{warm_fuzzy.id}"
    click_on "Edit Warm Fuzzy"
    expect(page).to have_css "h1", text: "Edit Warm Fuzzy #{warm_fuzzy.id}"
    expect(page).to have_css "a", text: "Show Warm Fuzzy"
    expect(page).to have_current_path edit_crud_warm_fuzzy_path(warm_fuzzy)
  end

  scenario "edit with errors" do
    warm_fuzzy = FactoryBot.create(:warm_fuzzy)
    visit "/crud/warm_fuzzies/#{warm_fuzzy.id}/edit"
    fill_in "title", with: ""
    click_on "update"
    expect(page).to have_css ".alert", text: "Title can't be blank"
  end

  scenario "edit successfully" do
    warm_fuzzy = FactoryBot.create(
      :warm_fuzzy,
      title: "Very Mice Code"
    )
    visit "/crud/warm_fuzzies/#{warm_fuzzy.id}/edit"
    fill_in "title", with: "Very Nice Code"
    click_on "update"

    expect(page).to have_css ".notice", text: "Warm Fuzzy updated"
    expect(page).to have_current_path crud_warm_fuzzy_path(warm_fuzzy)
    expect(page).to have_css "td", text: "Very Nice Code"
  end
end
