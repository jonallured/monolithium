require "rails_helper"

describe "Admin creates apache log item" do
  include_context "admin password matches"

  scenario "from list page" do
    visit "/crud/apache_log_items"
    click_on "New Apache Log Item"
    expect(page).to have_css "h1", text: "New Apache Log Item"
    expect(page).to have_css "a", text: "Apache Log Item List"
    expect(page).to have_current_path new_crud_apache_log_item_path
  end

  scenario "create with errors" do
    visit "/crud/apache_log_items/new"
    click_on "create"
    expect(page).to have_css ".alert", text: "REPLACE_ME"
    expect(page).to have_current_path new_crud_apache_log_item_path
  end

  scenario "create successfully" do
    visit "/crud/apache_log_items/new"
    fill_in "REPLACE_ME", with: "REPLACE_ME"
    click_on "create"

    expect(page).to have_css ".notice", text: "Apache Log Item created"

    apache_log_item = ApacheLogItem.last
    expect(page).to have_current_path crud_apache_log_item_path(apache_log_item)

    actual_values = page.all("tr").map do |table_row|
      table_row.all("td").map(&:text)
    end

    expect(actual_values).to eq(
      [
        ["REPLACE_ME", "REPLACE_ME"],
        ["Created At", apache_log_item.created_at.to_fs],
        ["Updated At", apache_log_item.updated_at.to_fs]
      ]
    )
  end
end
