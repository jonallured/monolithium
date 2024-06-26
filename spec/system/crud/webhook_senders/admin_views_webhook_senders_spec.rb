require "rails_helper"

describe "Admin views webhook senders" do
  include_context "admin password matches"

  scenario "from dashboard" do
    visit "/dashboard"
    click_on "Webhook Senders"
    expect(page).to have_css "h1", text: "Webhook Senders"
    expect(page).to have_current_path crud_webhook_senders_path
  end

  scenario "with no records" do
    visit "/crud/webhook_senders"
    expect(page.all("tbody tr").count).to eq 0
  end

  scenario "with a page of records" do
    FactoryBot.create_list(:webhook_sender, 3)
    visit "/crud/webhook_senders"
    expect(page.all("tbody tr").count).to eq 3
    expect(page).to_not have_css "nav.pagination"
  end

  scenario "with two pages of records" do
    FactoryBot.create_list(:webhook_sender, 4)
    visit "/crud/webhook_senders"
    expect(page.all("tbody tr").count).to eq 3
    expect(page).to have_css "nav.pagination"
  end
end
