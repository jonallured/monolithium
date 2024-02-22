require "rails_helper"

describe "Admin deletes csv upload" do
  include_context "admin password matches"

  let(:csv_upload) { FactoryBot.create(:csv_upload) }

  scenario "cancels delete" do
    visit "/admin/csv_uploads/#{csv_upload.id}"

    dismiss_confirm { click_on "Delete CSV Upload" }

    expect(CsvUpload.count).to eq 1
    expect(current_path).to eq admin_csv_upload_path(csv_upload)
  end

  scenario "confirms delete" do
    visit "/admin/csv_uploads/#{csv_upload.id}"

    accept_confirm { click_on "Delete CSV Upload" }

    expect(page).to have_css ".notice", text: "CSV Upload deleted"

    expect(CsvUpload.count).to eq 0
    expect(current_path).to eq admin_csv_uploads_path
  end
end
