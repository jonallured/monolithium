require "rails_helper"

describe "Admin edits csv upload" do
  include_context "admin password matches"

  scenario "from show page" do
    csv_upload = FactoryBot.create(:csv_upload)
    visit "/crud/csv_uploads/#{csv_upload.id}"
    click_on "Edit CSV Upload"
    expect(page).to have_css "h1", text: "Edit CSV Upload #{csv_upload.id}"
    expect(page).to have_css "a", text: "Show CSV Upload"
    expect(current_path).to eq edit_crud_csv_upload_path(csv_upload)
  end

  scenario "edit with errors" do
    csv_upload = FactoryBot.create(:csv_upload)
    visit "/crud/csv_uploads/#{csv_upload.id}/edit"
    fill_in "original filename", with: ""
    click_on "update"
    expect(page).to have_css ".alert", text: "Original filename can't be blank"
  end

  scenario "edit successfully" do
    csv_upload = FactoryBot.create(
      :csv_upload,
      original_filename: "some-gret-data.csl"
    )
    visit "/crud/csv_uploads/#{csv_upload.id}/edit"
    fill_in "original filename", with: "some-great-data.csv"
    click_on "update"

    expect(page).to have_css ".notice", text: "CSV Upload updated"
    expect(current_path).to eq crud_csv_upload_path(csv_upload)
    expect(page).to have_css "td", text: "some-great-data.csv"
  end
end
