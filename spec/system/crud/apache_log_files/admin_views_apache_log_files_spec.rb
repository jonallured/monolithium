require "rails_helper"

describe "Admin views apache log files" do
  include_context "admin password matches"

  scenario "from dashboard" do
    visit "/dashboard"
    click_on "Apache Log Files"
    expect(page).to have_css "h1", text: "Apache Log Files"
    expect(page).to have_current_path crud_apache_log_files_path
  end

  scenario "with no records" do
    visit "/crud/apache_log_files"
    table_rows = page.all("table tbody tr")
    expect(table_rows.count).to eq 0
  end

  scenario "with a page of records" do
    FactoryBot.create(:apache_log_file, dateext: "20251201", state: "transformed")
    FactoryBot.create(:apache_log_file, dateext: "20251202", state: "extracted")
    FactoryBot.create(:apache_log_file, dateext: "20251203", state: "pending")

    visit "/crud/apache_log_files"

    table_rows = page.all("table tbody tr")
    actual_table_data = table_rows.map do |row|
      _id, dateext, state, _created_at = row.all("td")
      [dateext.text, state.text].join(" ")
    end
    expected_table_data = [
      "20251203 pending",
      "20251202 extracted",
      "20251201 transformed"
    ]
    expect(actual_table_data).to eq(expected_table_data)
    expect(page).to_not have_css "nav.pagination"
  end

  scenario "with two pages of records" do
    FactoryBot.create_list(:apache_log_file, 4)
    visit "/crud/apache_log_files?page=2"
    expect(page.all("tbody tr").count).to eq 1
    expect(page).to have_css "nav.pagination"
  end
end
