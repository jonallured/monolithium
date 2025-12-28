require "rails_helper"

describe "Pages Detail Report" do
  include_context "admin password matches"

  scenario "with no log items" do
    visit "/analytics/pages/detail/2024/01"

    header_h1 = page.find("header nav h1")
    expect(header_h1.text).to eq "2024-01"

    prev_link, next_link = page.all("header nav a").to_a

    expect(prev_link.text).to eq "prev"
    expect(prev_link["href"]).to end_with "2023/12"

    expect(next_link.text).to eq "next"
    expect(next_link["href"]).to end_with "2024/02"

    description_p = page.find("main p")
    expect(description_p.text).to eq "Detail of 0 matching items with page (page 1 of 0)."

    headers = page.all("table thead th").map(&:text)
    expect(headers).to eq ["Requested At", "Page"]

    report_rows = page.all("table tbody tr")
    expect(report_rows.count).to eq 0
  end

  scenario "with no matching log items" do
    FactoryBot.create :apache_log_item, requested_at: Date.new(2024, 2, 1)

    visit "/analytics/pages/detail/2024/01"

    description_p = page.find("main p")
    expect(description_p.text).to eq "Detail of 0 matching items with page (page 1 of 0)."

    report_rows = page.all("table tbody tr")
    expect(report_rows.count).to eq 0
  end

  scenario "with a matching log item" do
    FactoryBot.create :apache_log_item, requested_at: Date.new(2024, 1, 14), request_path: "/all-posts.html"

    visit "/analytics/pages/detail/2024/01"

    description_p = page.find("main p")
    expect(description_p.text).to eq "Detail of 1 matching item with page (page 1 of 1)."

    report_rows = page.all("table tbody tr")
    actual_table_data = report_rows.map(&:text)

    expected_table_data = [
      "01/14/2024 12:00:00am /all-posts.html"
    ]

    expect(actual_table_data).to eq(expected_table_data)
  end

  scenario "with some matching log items" do
    FactoryBot.create :apache_log_item, requested_at: Date.new(2024, 1, 16), line_number: 3, request_path: "/podcasts.html"
    FactoryBot.create :apache_log_item, requested_at: Date.new(2024, 1, 14), line_number: 1, request_path: "/resume.html"
    FactoryBot.create :apache_log_item, requested_at: Date.new(2024, 1, 15), line_number: 2, request_path: "/all-posts.html"

    visit "/analytics/pages/detail/2024/01"

    description_p = page.find("main p")
    expect(description_p.text).to eq "Detail of 3 matching items with page (page 1 of 1)."

    report_rows = page.all("table tbody tr")
    actual_table_data = report_rows.map(&:text)

    expected_table_data = [
      "01/14/2024 12:00:00am /resume.html",
      "01/15/2024 12:00:00am /all-posts.html",
      "01/16/2024 12:00:00am /podcasts.html"
    ]

    expect(actual_table_data).to eq(expected_table_data)

    expect(page.all("nav.pagination").count).to eq 0
  end

  scenario "with more than one page of log items" do
    FactoryBot.create :apache_log_item, requested_at: Date.new(2024, 1, 16), line_number: 3, request_path: "/podcasts.html"
    FactoryBot.create :apache_log_item, requested_at: Date.new(2024, 1, 14), line_number: 1, request_path: "/resume.html"
    FactoryBot.create :apache_log_item, requested_at: Date.new(2024, 1, 17), line_number: 4, request_path: "/rotten.html"
    FactoryBot.create :apache_log_item, requested_at: Date.new(2024, 1, 15), line_number: 2, request_path: "/all-posts.html"

    visit "/analytics/pages/detail/2024/01?page=2"

    description_p = page.find("main p")
    expect(description_p.text).to eq "Detail of 4 matching items with page (page 2 of 2)."

    report_rows = page.all("table tbody tr")
    actual_table_data = report_rows.map(&:text)

    expected_table_data = [
      "01/17/2024 12:00:00am /rotten.html"
    ]

    expect(actual_table_data).to eq(expected_table_data)

    expect(page.all("nav.pagination").count).to eq 1
  end
end
