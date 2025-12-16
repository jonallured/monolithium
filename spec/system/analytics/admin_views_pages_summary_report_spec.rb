require "rails_helper"

describe "Pages Summary Report" do
  include_context "admin password matches"

  scenario "with no log items" do
    visit "/analytics/pages/summary/2024/01"

    header_h1 = page.find("header nav h1")
    expect(header_h1.text).to eq "2024-01"

    prev_link, next_link = page.all("header nav a").to_a

    expect(prev_link.text).to eq "prev"
    expect(prev_link["href"]).to end_with "2023/12"

    expect(next_link.text).to eq "next"
    expect(next_link["href"]).to end_with "2024/02"

    description_p = page.find("main p")
    expect(description_p.text).to eq "Summary of 0 matching items grouped by page into 0 rows."

    headers = page.all("table thead th").map(&:text)
    expect(headers).to eq %w[Page Count]

    report_rows = page.all("table tbody tr")
    expect(report_rows.count).to eq 0
  end

  scenario "with no matching log items" do
    FactoryBot.create :apache_log_item, requested_at: Date.new(2024, 2, 1)

    visit "/analytics/pages/summary/2024/01"

    description_p = page.find("main p")
    expect(description_p.text).to eq "Summary of 0 matching items grouped by page into 0 rows."

    report_rows = page.all("table tbody tr")
    expect(report_rows.count).to eq 0
  end

  scenario "with a matching log item" do
    FactoryBot.create :apache_log_item, requested_at: Date.new(2024, 1, 14), request_path: "/all-posts.html"

    visit "/analytics/pages/summary/2024/01"

    description_p = page.find("main p")
    expect(description_p.text).to eq "Summary of 1 matching item grouped by page into 1 row."

    report_rows = page.all("table tbody tr")
    actual_table_data = report_rows.map(&:text)

    expected_table_data = [
      "/all-posts.html 1"
    ]

    expect(actual_table_data).to eq(expected_table_data)
  end

  scenario "with some matching log items" do
    FactoryBot.create :apache_log_item, requested_at: Date.new(2024, 1, 14), line_number: 1, request_path: "/resume.html"
    FactoryBot.create :apache_log_item, requested_at: Date.new(2024, 1, 15), line_number: 2, request_path: "/all-posts.html"
    FactoryBot.create :apache_log_item, requested_at: Date.new(2024, 1, 16), line_number: 3, request_path: "/podcasts.html"

    visit "/analytics/pages/summary/2024/01"

    description_p = page.find("main p")
    expect(description_p.text).to eq "Summary of 3 matching items grouped by page into 3 rows."

    report_rows = page.all("table tbody tr")
    actual_table_data = report_rows.map(&:text)

    expected_table_data = [
      "/all-posts.html 1",
      "/podcasts.html 1",
      "/resume.html 1"
    ]

    expect(actual_table_data).to eq(expected_table_data)
  end

  scenario "with some grouped log items" do
    FactoryBot.create :apache_log_item, requested_at: Date.new(2024, 1, 14), line_number: 1, request_path: "/all-posts.html"
    FactoryBot.create :apache_log_item, requested_at: Date.new(2024, 1, 15), line_number: 2, request_path: "/resume.html"
    FactoryBot.create :apache_log_item, requested_at: Date.new(2024, 1, 16), line_number: 3, request_path: "/resume.html"

    visit "/analytics/pages/summary/2024/01"

    description_p = page.find("main p")
    expect(description_p.text).to eq "Summary of 3 matching items grouped by page into 2 rows."

    report_rows = page.all("table tbody tr")
    actual_table_data = report_rows.map(&:text)

    expected_table_data = [
      "/resume.html 2",
      "/all-posts.html 1"
    ]

    expect(actual_table_data).to eq(expected_table_data)
  end
end
