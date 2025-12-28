require "rails_helper"

describe "Admin creates apache log file" do
  include_context "admin password matches"

  scenario "from list page" do
    visit "/crud/apache_log_files"
    click_on "New Apache Log File"
    expect(page).to have_css "h1", text: "New Apache Log File"
    expect(page).to have_css "a", text: "Apache Log File List"
    expect(page).to have_current_path new_crud_apache_log_file_path
  end

  scenario "create with errors" do
    visit "/crud/apache_log_files/new"
    click_on "create"
    expect(page).to have_css ".alert", text: "REPLACE_ME"
    expect(page).to have_current_path new_crud_apache_log_file_path
  end

  scenario "create successfully" do
    visit "/crud/apache_log_files/new"
    fill_in "REPLACE_ME", with: "REPLACE_ME"
    click_on "create"

    expect(page).to have_css ".notice", text: "Apache Log File created"

    apache_log_file = ApacheLogFile.last
    expect(page).to have_current_path crud_apache_log_file_path(apache_log_file)

    actual_values = page.all("tr").map do |table_row|
      table_row.all("td").map(&:text)
    end

    expect(actual_values).to eq(
      [
        ["REPLACE_ME", "REPLACE_ME"],
        ["Created At", apache_log_file.created_at.to_fs],
        ["Updated At", apache_log_file.updated_at.to_fs]
      ]
    )
  end
end
