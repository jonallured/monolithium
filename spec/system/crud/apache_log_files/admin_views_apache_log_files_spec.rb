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
    expect(page.all("tbody tr").count).to eq 0
  end

  scenario "with a page of records" do
    FactoryBot.create_list(:apache_log_file, 3)
    visit "/crud/apache_log_files"
    expect(page.all("tbody tr").count).to eq 3
    expect(page).to_not have_css "nav.pagination"
  end

  scenario "with two pages of records" do
    FactoryBot.create_list(:apache_log_file, 4)
    visit "/crud/apache_log_files"
    expect(page.all("tbody tr").count).to eq 3
    expect(page).to have_css "nav.pagination"
  end
end
