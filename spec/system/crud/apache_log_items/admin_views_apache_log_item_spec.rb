require "rails_helper"

describe "Admin views apache log item" do
  include_context "admin password matches"

  scenario "from list page" do
    apache_log_item = FactoryBot.create(:apache_log_item)
    visit "/crud/apache_log_items"
    click_on apache_log_item.id.to_s
    expect(page).to have_css "h1", text: "Apache Log Item #{apache_log_item.id}"
    expect(page).to have_css "a", text: "Apache Log Item List"
    expect(page).to have_current_path crud_apache_log_item_path(apache_log_item)
  end

  scenario "viewing a record" do
    apache_log_item = FactoryBot.create(
      :apache_log_item,
      browser_name: "Safari",
      line_number: 1,
      port: "443",
      raw_line: "GET /index.html",
      referrer_host: "jon.zone",
      remote_ip_address: "1.1.1.1",
      remote_logname: "-",
      remote_user: "-",
      request_method: "GET",
      request_params: nil,
      request_path: "/index.html",
      request_protocol: "HTTP1.1",
      request_referrer: "https://jon.zone/post-1",
      request_user_agent: "Safari",
      requested_at: Time.now,
      response_size: 100,
      response_status: "200",
      website: "www.jonallured.com"
    )

    visit "/crud/apache_log_items/#{apache_log_item.id}"

    actual_values = page.all("tr").map do |table_row|
      table_row.all("td").map(&:text)
    end

    expect(actual_values).to eq(
      [
        ["ApacheLogFile ID", apache_log_item.apache_log_file_id.to_s],
        ["Browser Name", "Safari"],
        ["Line Number", "1"],
        ["Port", "443"],
        ["Raw Line", "GET /index.html"],
        ["Referrer Host", "jon.zone"],
        ["Remote IP Address", "1.1.1.1"],
        ["Remote Logname", "-"],
        ["Remote User", "-"],
        ["Request Method", "GET"],
        ["Request Params", ""],
        ["Request Path", "/index.html"],
        ["Request Protocol", "HTTP1.1"],
        ["Request Referrer", "https://jon.zone/post-1"],
        ["Request User Agent", "Safari"],
        ["Requested At", apache_log_item.requested_at.to_fs],
        ["Response Size", "100"],
        ["Response Status", "200"],
        ["Website", "www.jonallured.com"],
        ["Created At", apache_log_item.created_at.to_fs],
        ["Updated At", apache_log_item.updated_at.to_fs]
      ]
    )
  end

  scenario "views random record" do
    apache_log_item = FactoryBot.create(:apache_log_item)
    expect(ApacheLogItem).to receive(:random).and_return(apache_log_item)

    visit "/crud/apache_log_items"
    click_on "Random Apache Log Item"

    expect(page).to have_css "h1", text: "Apache Log Item #{apache_log_item.id}"
    expect(page).to have_current_path crud_apache_log_item_path(apache_log_item)
  end
end
