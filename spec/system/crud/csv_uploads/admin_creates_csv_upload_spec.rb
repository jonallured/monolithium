require "rails_helper"

describe "Admin creates csv upload" do
  include_context "admin password matches"

  scenario "from list page" do
    visit "/crud/csv_uploads"
    click_on "New CSV Upload"
    expect(page).to have_css "h1", text: "New CSV Upload"
    expect(page).to have_css "a", text: "CSV Upload List"
    expect(page).to have_current_path new_crud_csv_upload_path
  end

  scenario "create with parser error" do
    visit "/crud/csv_uploads/new"
    click_on "create"
    select = page.find("#csv_upload_parser_class_name")
    error_message = select.native.attribute("validationMessage")
    expect(error_message).to eq "Please select an item in the list."
  end

  scenario "create with file error" do
    visit "/crud/csv_uploads/new"
    select "WellsFargoParser", from: "csv_upload_parser_class_name"
    click_on "create"
    file_input = page.find("#file_picker")
    error_message = file_input.native.attribute("validationMessage")
    expect(error_message).to eq "Please select a file."
  end

  scenario "create with empty file error" do
    visit "/crud/csv_uploads/new"
    select "WellsFargoParser", from: "csv_upload_parser_class_name"
    attach_file "file", "spec/csv_files/empty.csv"
    click_on "create"
    expect(page).to have_content "Data can't be blank"
    expect(page).to have_css ".alert", text: "Data can't be blank"
    expect(page).to have_current_path new_crud_csv_upload_path
  end

  scenario "create successfully" do
    visit "/crud/csv_uploads/new"
    select "WellsFargoParser", from: "csv_upload_parser_class_name"
    attach_file "file", "spec/csv_files/one_wf_transaction.csv"
    click_on "create"

    expect(page).to have_css ".notice", text: "CSV Upload created"
    expect(ParseCsvUploadJob).to have_been_enqueued

    csv_upload = CsvUpload.last
    expect(page).to have_current_path crud_csv_upload_path(csv_upload)

    actual_values = page.all("tr").map do |table_row|
      table_row.all("td").map(&:text)
    end

    expect(actual_values).to eq(
      [
        ["Parser Class Name", "WellsFargoParser"],
        ["Original Filename", "one_wf_transaction.csv"],
        ["Created At", csv_upload.created_at.to_formatted_s(:long)],
        ["Updated At", csv_upload.updated_at.to_formatted_s(:long)]
      ]
    )
  end
end
