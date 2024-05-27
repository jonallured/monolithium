require "rails_helper"

describe "Admin creates webhook sender" do
  include_context "admin password matches"

  scenario "from list page" do
    visit "/crud/webhook_senders"
    click_on "New Webhook Sender"
    expect(page).to have_css "h1", text: "New Webhook Sender"
    expect(page).to have_css "a", text: "Webhook Sender List"
    expect(page).to have_current_path new_crud_webhook_sender_path
  end

  scenario "create with errors" do
    visit "/crud/webhook_senders/new"
    click_on "create"
    expect(page).to have_css ".alert", text: "Name can't be blank and Parser can't be blank"
    expect(page).to have_current_path new_crud_webhook_sender_path
  end

  scenario "create successfully" do
    visit "/crud/webhook_senders/new"
    fill_in "name", with: "Chatty Service"
    fill_in "parser", with: "ChattyServiceParser"
    click_on "create"

    expect(page).to have_css ".notice", text: "Webhook Sender created"

    webhook_sender = WebhookSender.last
    expect(page).to have_current_path crud_webhook_sender_path(webhook_sender)

    actual_values = page.all("tr").map do |table_row|
      table_row.all("td").map(&:text)
    end

    expect(actual_values).to eq(
      [
        ["Name", "Chatty Service"],
        ["Parser", "ChattyServiceParser"],
        ["Created At", webhook_sender.created_at.to_fs],
        ["Updated At", webhook_sender.updated_at.to_fs]
      ]
    )
  end
end
