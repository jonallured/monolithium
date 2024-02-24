require "rails_helper"

describe "Admin views csv upload" do
  include_context "admin password matches"

  scenario "from list page" do
    csv_upload = FactoryBot.create(:csv_upload)
    visit "/crud/csv_uploads"
    click_on csv_upload.id.to_s
    expect(page).to have_css "h1", text: "CSV Upload #{csv_upload.id}"
    expect(page).to have_css "a", text: "CSV Upload List"
    expect(page).to have_current_path crud_csv_upload_path(csv_upload)
  end

  scenario "viewing a record" do
    csv_upload = FactoryBot.create(
      :csv_upload,
      data: "foo,bar,baz",
      original_filename: "dummy-data.csv",
      parser_class_name: "DummyParser"
    )

    visit "/crud/csv_uploads/#{csv_upload.id}"

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

  scenario "views random record" do
    csv_upload = FactoryBot.create(:csv_upload)
    expect(CsvUpload).to receive(:random).and_return(csv_upload)

    visit "/crud/csv_uploads"
    click_on "Random CSV Upload"

    expect(page).to have_css "h1", text: "CSV Upload #{csv_upload.id}"
    expect(page).to have_current_path crud_csv_upload_path(csv_upload)
  end
end
