require "rails_helper"

describe "Admin edits webhook sender" do
  include_context "admin password matches"

  scenario "from show page" do
    webhook_sender = FactoryBot.create(:webhook_sender)
    visit "/crud/webhook_senders/#{webhook_sender.id}"
    click_on "Edit Webhook Sender"
    expect(page).to have_css "h1", text: "Edit Webhook Sender #{webhook_sender.id}"
    expect(page).to have_css "a", text: "Show Webhook Sender"
    expect(page).to have_current_path edit_crud_webhook_sender_path(webhook_sender)
  end

  scenario "edit with errors" do
    webhook_sender = FactoryBot.create(:webhook_sender)
    visit "/crud/webhook_senders/#{webhook_sender.id}/edit"
    fill_in "name", with: ""
    click_on "update"
    expect(page).to have_css ".alert", text: "Name can't be blank"
  end

  scenario "edit successfully" do
    webhook_sender = FactoryBot.create(
      :webhook_sender,
      name: "Chatty Serbice"
    )
    visit "/crud/webhook_senders/#{webhook_sender.id}/edit"
    fill_in "name", with: "Chatty Service"
    click_on "update"

    expect(page).to have_css ".notice", text: "Webhook Sender updated"
    expect(page).to have_current_path crud_webhook_sender_path(webhook_sender)
    expect(page).to have_css "td", text: "Chatty Service"
  end
end
