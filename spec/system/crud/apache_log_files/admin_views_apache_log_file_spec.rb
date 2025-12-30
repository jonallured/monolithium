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
      dateext: "20251201",
      parsed_entries: [{request_path: "/index.html"}, {request_path: "/admin"}],
      raw_lines: "GET /index.html\nPOST /admin\n",
      state: "pending"
    )

    visit "/crud/apache_log_files/#{apache_log_file.id}"

    actual_values = page.all("tr").map do |table_row|
      table_row.all("td").map(&:text)
    end

    expect(actual_values).to eq(
      [
        ["dateext", "20251201"],
        ["State", "pending"],
        ["Created At", apache_log_file.created_at.to_fs],
        ["Updated At", apache_log_file.updated_at.to_fs]
      ]
    )

    expect(page.all("h2").map(&:text)).to eq ["Raw Lines", "Parsed Entries"]

    actual_pre_text = page.all("pre").map { |pre_tag| pre_tag.native.text }
    expect(actual_pre_text).to eq(
      [
        apache_log_file.raw_lines,
        JSON.pretty_generate(apache_log_file.parsed_entries)
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
