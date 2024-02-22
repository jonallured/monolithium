require "rails_helper"

describe "Admin views CsvUploads" do
  include_context "admin password matches"

  scenario "from dashboard" do
    visit "/dashboard"
    click_on "CSV Uploads"
    expect(page).to have_css "h1", text: "CSV Uploads"
    expect(current_path).to eq admin_csv_uploads_path
  end

  scenario "with no records" do
    visit "/admin/csv_uploads"
    expect(page.all("tbody tr").count).to eq 0
  end

  scenario "with a page of records" do
    FactoryBot.create_list(:csv_upload, 3)
    visit "/admin/csv_uploads"
    expect(page.all("tbody tr").count).to eq 3
    expect(page).to_not have_css "nav.pagination"
  end

  scenario "with two pages of records" do
    FactoryBot.create_list(:csv_upload, 4)
    visit "/admin/csv_uploads"
    expect(page.all("tbody tr").count).to eq 3
    expect(page).to have_css "nav.pagination"
  end
end
