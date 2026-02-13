require "rails_helper"

describe "Admin creates boop" do
  include_context "admin password matches"

  scenario "from list page" do
    visit "/crud/boops"
    click_on "New Boop"
    expect(page).to have_css "h1", text: "New Boop"
    expect(page).to have_css "a", text: "Boop List"
    expect(page).to have_current_path new_crud_boop_path
  end

  scenario "create with errors" do
    visit "/crud/boops/new"
    click_on "create"
    expect(page).to have_css ".alert", text: "Display type is not included in the list"
    expect(page).to have_current_path new_crud_boop_path
  end

  scenario "create successfully" do
    visit "/crud/boops/new"
    fill_in "number", with: "1"
    fill_in "display_type", with: "skull"
    click_on "create"

    expect(page).to have_css ".notice", text: "Boop created"

    boop = Boop.last
    expect(page).to have_current_path crud_boop_path(boop)

    actual_values = page.all("tr").map do |table_row|
      table_row.all("td").map(&:text)
    end

    expect(actual_values).to eq(
      [
        ["Number", "1"],
        ["Display Type", "skull"],
        ["Dismissed At", ""],
        ["Created At", boop.created_at.to_fs],
        ["Updated At", boop.updated_at.to_fs]
      ]
    )
  end
end
