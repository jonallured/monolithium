require "rails_helper"

describe "Admin views apache log file" do
  include_context "admin password matches"

  scenario "from list page" do
    apache_log_file = FactoryBot.create(:apache_log_file)
    visit "/crud/apache_log_files"
    click_on apache_log_file.id.to_s
    expect(page).to have_css "h1", text: "Apache Log File #{apache_log_file.id}"
    expect(page).to have_css "a", text: "Apache Log File List"
    expect(page).to have_current_path crud_apache_log_file_path(apache_log_file)
  end

  scenario "viewing a record" do
    apache_log_file = FactoryBot.create(
      :apache_log_file,
      REPLACE_ME: "REPLACE_ME"
    )

    visit "/crud/apache_log_files/#{apache_log_file.id}"

    actual_values = page.all("tr").map do |table_row|
      table_row.all("td").map(&:text)
    end

    expect(actual_values).to eq(
      [
        ["REPLACE_ME", "REPLACE_ME"],
        ["Created At", apache_log_file.created_at.to_fs],
        ["Updated At", apache_log_file.updated_at.to_fs]
      ]
    )
  end

  scenario "views random record" do
    apache_log_file = FactoryBot.create(:apache_log_file)
    expect(ApacheLogFile).to receive(:random).and_return(apache_log_file)

    visit "/crud/apache_log_files"
    click_on "Random Apache Log File"

    expect(page).to have_css "h1", text: "Apache Log File #{apache_log_file.id}"
    expect(page).to have_current_path crud_apache_log_file_path(apache_log_file)
  end
end
