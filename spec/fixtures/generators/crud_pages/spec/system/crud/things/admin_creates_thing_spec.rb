require "rails_helper"

describe "Admin creates thing" do
  include_context "admin password matches"

  scenario "from list page" do
    visit "/crud/things"
    click_on "New Thing"
    expect(page).to have_css "h1", text: "New Thing"
    expect(page).to have_css "a", text: "Thing List"
    expect(page).to have_current_path new_crud_thing_path
  end

  scenario "create with errors" do
    visit "/crud/things/new"
    click_on "create"
    expect(page).to have_css ".alert", text: "REPLACE_ME"
    expect(page).to have_current_path new_crud_thing_path
  end

  scenario "create successfully" do
    visit "/crud/things/new"
    fill_in "REPLACE_ME", with: "REPLACE_ME"
    click_on "create"

    expect(page).to have_css ".notice", text: "Thing created"

    thing = Thing.last
    expect(page).to have_current_path crud_thing_path(thing)

    actual_values = page.all("tr").map do |table_row|
      table_row.all("td").map(&:text)
    end

    expect(actual_values).to eq(
      [
        ["REPLACE_ME", "REPLACE_ME"],
        ["Created At", thing.created_at.to_fs],
        ["Updated At", thing.updated_at.to_fs]
      ]
    )
  end
end
