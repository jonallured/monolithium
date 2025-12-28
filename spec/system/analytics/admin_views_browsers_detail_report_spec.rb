require "rails_helper"

describe "Browsers Detail Report" do
  include_context "admin password matches"

  scenario "with no log items" do
    visit "/analytics/browsers/detail/2024/01"

    header_h1 = page.find("header nav h1")
    expect(header_h1.text).to eq "2024-01"

    prev_link, next_link = page.all("header nav a").to_a

    expect(prev_link.text).to eq "prev"
    expect(prev_link["href"]).to end_with "2023/12"

    expect(next_link.text).to eq "next"
    expect(next_link["href"]).to end_with "2024/02"

    description_p = page.find("main p")
    expect(description_p.text).to eq "Detail of 0 matching items with browser (page 1 of 0)."

    headers = page.all("table thead th").map(&:text)
    expect(headers).to eq ["Requested At", "Browser"]

    report_rows = page.all("table tbody tr")
    expect(report_rows.count).to eq 0
  end

  scenario "with no matching log items" do
    FactoryBot.create :apache_log_item, requested_at: Date.new(2024, 2, 1)

    visit "/analytics/browsers/detail/2024/01"

    description_p = page.find("main p")
    expect(description_p.text).to eq "Detail of 0 matching items with browser (page 1 of 0)."

    report_rows = page.all("table tbody tr")
    expect(report_rows.count).to eq 0
  end

  scenario "with a matching log item" do
    FactoryBot.create :apache_log_item, requested_at: Date.new(2024, 1, 14), browser_name: "Safari"

    visit "/analytics/browsers/detail/2024/01"

    description_p = page.find("main p")
    expect(description_p.text).to eq "Detail of 1 matching item with browser (page 1 of 1)."

    report_rows = page.all("table tbody tr")
    actual_table_data = report_rows.map(&:text)

    expected_table_data = [
      "01/14/2024 12:00:00am Safari"
    ]

    expect(actual_table_data).to eq(expected_table_data)
  end

  scenario "with some matching log items" do
    FactoryBot.create :apache_log_item, requested_at: Date.new(2024, 1, 16), line_number: 3, browser_name: "FireFox"
    FactoryBot.create :apache_log_item, requested_at: Date.new(2024, 1, 14), line_number: 1, browser_name: "Safari"
    FactoryBot.create :apache_log_item, requested_at: Date.new(2024, 1, 15), line_number: 2, browser_name: "Chrome"

    visit "/analytics/browsers/detail/2024/01"

    description_p = page.find("main p")
    expect(description_p.text).to eq "Detail of 3 matching items with browser (page 1 of 1)."

    report_rows = page.all("table tbody tr")
    actual_table_data = report_rows.map(&:text)

    expected_table_data = [
      "01/14/2024 12:00:00am Safari",
      "01/15/2024 12:00:00am Chrome",
      "01/16/2024 12:00:00am FireFox"
    ]

    expect(actual_table_data).to eq(expected_table_data)

    expect(page.all("nav.pagination").count).to eq 0
  end

  scenario "with more than one browser of log items" do
    FactoryBot.create :apache_log_item, requested_at: Date.new(2024, 1, 16), line_number: 3, browser_name: "FireFox"
    FactoryBot.create :apache_log_item, requested_at: Date.new(2024, 1, 14), line_number: 1, browser_name: "Safari"
    FactoryBot.create :apache_log_item, requested_at: Date.new(2024, 1, 17), line_number: 4, browser_name: "Opera"
    FactoryBot.create :apache_log_item, requested_at: Date.new(2024, 1, 15), line_number: 2, browser_name: "Chrome"
    visit "/analytics/browsers/detail/2024/01?page=2"

    description_p = page.find("main p")
    expect(description_p.text).to eq "Detail of 4 matching items with browser (page 2 of 2)."

    report_rows = page.all("table tbody tr")
    actual_table_data = report_rows.map(&:text)

    expected_table_data = [
      "01/17/2024 12:00:00am Opera"
    ]

    expect(actual_table_data).to eq(expected_table_data)

    expect(page.all("nav.pagination").count).to eq 1
  end
end
