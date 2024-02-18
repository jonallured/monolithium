require "rails_helper"

describe "Admin views CsvUploads" do
  include_context "admin password matches"

  scenario "views CsvUploads" do
    FactoryBot.create_list(:csv_upload, 3)
    visit "/admin/csv_uploads"
    expect(page).to have_css "a", text: "New CSV Upload"
    expect(page.all("tbody tr").count).to eq 3
  end
end
