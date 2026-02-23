require "rails_helper"

describe "Admin creates chore" do
  include_context "admin password matches"

  scenario "from list page" do
    visit "/crud/chores"
    click_on "New Chore"
    expect(page).to have_css "h1", text: "New Chore"
    expect(page).to have_css "a", text: "Chore List"
    expect(page).to have_current_path new_crud_chore_path
  end

  scenario "create with errors" do
    visit "/crud/chores/new"
    click_on "create"
    expect(page).to have_css ".alert", text: "Due days can't be blank and Title can't be blank"
    expect(page).to have_current_path new_crud_chore_path
  end

  scenario "create successfully" do
    visit "/crud/chores/new"
    fill_in "title", with: "Clean Up"
    check "all"
    click_on "create"

    expect(page).to have_css ".notice", text: "Chore created"

    chore = Chore.last
    expect(page).to have_current_path crud_chore_path(chore)

    actual_values = page.all("tr").map do |table_row|
      table_row.all("td").map(&:text)
    end

    expect(actual_values).to eq(
      [
        ["Title", "Clean Up"],
        ["Assignee", "jon"],
        ["Due Days", "0 1 2 3 4 5 6"],
        ["Created At", chore.created_at.to_fs],
        ["Updated At", chore.updated_at.to_fs]
      ]
    )
  end
end
