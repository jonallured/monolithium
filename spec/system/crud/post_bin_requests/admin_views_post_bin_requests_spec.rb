require "rails_helper"

describe "Admin views post bin requests" do
  include_context "admin password matches"

  scenario "from dashboard" do
    visit "/dashboard"
    click_on "Post Bin Requests"
    expect(page).to have_css "h1", text: "Post Bin Requests"
    expect(page).to have_current_path crud_post_bin_requests_path
  end

  scenario "with no records" do
    visit "/crud/post_bin_requests"
    expect(page.all("tbody tr").count).to eq 0
  end

  scenario "with a page of records" do
    FactoryBot.create_list(:post_bin_request, 3)
    visit "/crud/post_bin_requests"
    expect(page.all("tbody tr").count).to eq 3
    expect(page).to_not have_css "nav.pagination"
  end

  scenario "with two pages of records" do
    FactoryBot.create_list(:post_bin_request, 4)
    visit "/crud/post_bin_requests"
    expect(page.all("tbody tr").count).to eq 3
    expect(page).to have_css "nav.pagination"
  end
end
