require "rails_helper"

describe "Admin creates apache log item" do
  include_context "admin password matches"

  scenario "from list page" do
    visit "/crud/apache_log_items"
    click_on "New Apache Log Item"
    expect(page).to have_css "h1", text: "New Apache Log Item"
    expect(page).to have_css "a", text: "Apache Log Item List"
    expect(page).to have_current_path new_crud_apache_log_item_path
  end

  scenario "create with errors" do
    visit "/crud/apache_log_items/new"
    click_on "create"
    expected_error_message = [
      "Apache log file must exist",
      "Line number can't be blank",
      "Raw line can't be blank",
      "Port irrelevant",
      "Request method irrelevant",
      "Request path irrelevant",
      "Request user agent irrelevant",
      "Response status irrelevant"
    ].join(", ") + ", and Website irrelevant"
    expect(page).to have_css ".alert", text: expected_error_message
    expect(page).to have_current_path new_crud_apache_log_item_path
  end

  scenario "create successfully" do
    visit "/crud/apache_log_items/new"
    apache_log_file = FactoryBot.create(:apache_log_file)
    fill_in "ApacheLogFile record ID", with: apache_log_file.id
    fill_in "line number", with: "1"
    fill_in "raw line", with: "GET /index.html"
    fill_in "port", with: "443"
    fill_in "request method", with: "GET"
    fill_in "request path", with: "/index.html"
    fill_in "request user agent", with: "Safari"
    fill_in "response status", with: "200"
    fill_in "website", with: "www.jonallured.com"
    click_on "create"

    expect(page).to have_css ".notice", text: "Apache Log Item created"

    apache_log_item = ApacheLogItem.last
    expect(page).to have_current_path crud_apache_log_item_path(apache_log_item)

    actual_values = page.all("tr").map do |table_row|
      table_row.all("td").map(&:text)
    end

    expect(actual_values).to match_array(
      [
        ["ApacheLogFile ID", apache_log_item.apache_log_file_id.to_s],
        ["Browser Name", ""],
        ["Line Number", "1"],
        ["Port", "443"],
        ["Raw Line", "GET /index.html"],
        ["Referrer Host", ""],
        ["Remote IP Address", ""],
        ["Remote Logname", ""],
        ["Remote User", ""],
        ["Request Method", "GET"],
        ["Request Params", ""],
        ["Request Path", "/index.html"],
        ["Request Protocol", ""],
        ["Request Referrer", ""],
        ["Request User Agent", "Safari"],
        ["Requested At", ""],
        ["Response Size", ""],
        ["Response Status", "200"],
        ["Website", "www.jonallured.com"],
        ["Created At", apache_log_item.created_at.to_fs],
        ["Updated At", apache_log_item.updated_at.to_fs]
      ]
    )
  end
end
