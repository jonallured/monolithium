require "rails_helper"

describe "Admin edits apache log item" do
  include_context "admin password matches"

  scenario "from show page" do
    apache_log_item = FactoryBot.create(:apache_log_item)
    visit "/crud/apache_log_items/#{apache_log_item.id}"
    click_on "Edit Apache Log Item"
    expect(page).to have_css "h1", text: "Edit Apache Log Item #{apache_log_item.id}"
    expect(page).to have_css "a", text: "Show Apache Log Item"
    expect(page).to have_current_path edit_crud_apache_log_item_path(apache_log_item)
  end

  scenario "edit with errors" do
    apache_log_item = FactoryBot.create(
      :apache_log_item,
      port: "443",
      request_method: "GET",
      request_path: "/index.html",
      request_user_agent: "Safari",
      response_status: "200"
    )
    visit "/crud/apache_log_items/#{apache_log_item.id}/edit"
    fill_in "website", with: "example.com"
    click_on "update"
    expect(page).to have_css ".alert", text: "Website irrelevant"
  end

  scenario "edit successfully" do
    apache_log_item = FactoryBot.create(
      :apache_log_item,
      port: "443",
      request_method: "GET",
      request_path: "/typo.html",
      request_user_agent: "Safari",
      response_status: "200",
      website: "www.jonallured.com"
    )
    visit "/crud/apache_log_items/#{apache_log_item.id}/edit"
    fill_in "request path", with: "/correct.html"
    click_on "update"

    expect(page).to have_css ".notice", text: "Apache Log Item updated"
    expect(page).to have_current_path crud_apache_log_item_path(apache_log_item)
    expect(page).to have_css "td", text: "/correct.html"
  end
end
