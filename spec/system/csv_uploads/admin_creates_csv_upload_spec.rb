require "rails_helper"

describe "Admin creates CsvUpload" do
  include_context "admin password matches"

  scenario "without a parser" do
    visit "/admin/csv_uploads/new"
    click_on "create"
    expect(CsvUpload.count).to eq 0
    select = page.find("#csv_upload_parser_class_name")
    error_message = select.native.attribute("validationMessage")
    expect(error_message).to eq "Please select an item in the list."
  end

  scenario "without a file" do
    visit "/admin/csv_uploads/new"
    select "WellsFargoParser", from: "csv_upload_parser_class_name"
    click_on "create"
    expect(CsvUpload.count).to eq 0
    file_input = page.find("#file_picker")
    error_message = file_input.native.attribute("validationMessage")
    expect(error_message).to eq "Please select a file."
  end

  scenario "with an empty file" do
    visit "/admin/csv_uploads/new"
    select "WellsFargoParser", from: "csv_upload_parser_class_name"
    attach_file "file", "spec/csv_files/empty.csv"
    click_on "create"
    expect(CsvUpload.count).to eq 0
    expect(page).to have_content "Data can't be blank"
  end

  scenario "with valid financial transactions" do
    visit "/admin/csv_uploads/new"
    select "WellsFargoParser", from: "csv_upload_parser_class_name"
    attach_file "file", "spec/csv_files/one_wf_transaction.csv"
    click_on "create"
    expect(page).to have_content "CSV Upload successfully created"
    csv_upload = CsvUpload.last
    expect(page).to have_content "CSV Upload #{csv_upload.id}"
    expect(ParseCsvUploadJob).to have_been_enqueued
  end
end
