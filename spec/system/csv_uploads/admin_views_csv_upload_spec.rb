require "rails_helper"

describe "Admin views CsvUpload" do
  include_context "admin password matches"

  scenario "views CsvUpload" do
    csv_upload = FactoryBot.create(
      :csv_upload,
      data: "foo,bar,baz",
      original_filename: "dummy-data.csv",
      parser_class_name: "DummyParser"
    )

    visit "/admin/csv_uploads/#{csv_upload.id}"

    expect(page).to have_content "CSV Upload #{csv_upload.id}"

    actual_values = page.all("tr").map do |table_row|
      table_row.all("td").map(&:text)
    end

    expect(actual_values).to eq(
      [
        ["Parser Class Name", "DummyParser"],
        ["Original Filename", "dummy-data.csv"],
        ["Created At", csv_upload.created_at.to_formatted_s(:long)],
        ["Updated At", csv_upload.updated_at.to_formatted_s(:long)]
      ]
    )

    expect(page.find("code").text).to eq csv_upload.data
  end
end