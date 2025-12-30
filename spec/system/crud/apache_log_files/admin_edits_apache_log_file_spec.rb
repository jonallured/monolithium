require "rails_helper"

describe "Admin edits apache log file" do
  include_context "admin password matches"

  scenario "from show page" do
    apache_log_file = FactoryBot.create(:apache_log_file)
    visit "/crud/apache_log_files/#{apache_log_file.id}"
    click_on "Edit Apache Log File"
    expect(page).to have_css "h1", text: "Edit Apache Log File #{apache_log_file.id}"
    expect(page).to have_css "a", text: "Show Apache Log File"
    expect(page).to have_current_path edit_crud_apache_log_file_path(apache_log_file)
  end

  scenario "edit with errors" do
    apache_log_file = FactoryBot.create(:apache_log_file)
    visit "/crud/apache_log_files/#{apache_log_file.id}/edit"
    fill_in "dateext", with: ""
    click_on "update"
    expect(page).to have_css ".alert", text: "Dateext can't be blank"
  end

  scenario "edit successfully" do
    apache_log_file = FactoryBot.create(
      :apache_log_file,
      dateext: "200251201"
    )
    visit "/crud/apache_log_files/#{apache_log_file.id}/edit"
    fill_in "dateext", with: "20251201"
    click_on "update"

    expect(page).to have_css ".notice", text: "Apache Log File updated"
    expect(page).to have_current_path crud_apache_log_file_path(apache_log_file)
    expect(page).to have_css "td", text: "20251201"
  end
end
