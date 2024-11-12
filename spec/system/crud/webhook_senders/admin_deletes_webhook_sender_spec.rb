require "rails_helper"

describe "Admin deletes webhook sender" do
  include_context "admin password matches"

  let(:webhook_sender) { FactoryBot.create(:webhook_sender) }

  scenario "cancels delete", js: true do
    visit "/crud/webhook_senders/#{webhook_sender.id}"

    dismiss_confirm { click_on "Delete Webhook Sender" }

    expect(WebhookSender.count).to eq 1
    expect(page).to have_current_path crud_webhook_sender_path(webhook_sender)
  end

  scenario "confirms delete", js: true do
    visit "/crud/webhook_senders/#{webhook_sender.id}"

    accept_confirm { click_on "Delete Webhook Sender" }

    expect(page).to have_css ".notice", text: "Webhook Sender deleted"

    expect(WebhookSender.count).to eq 0
    expect(page).to have_current_path crud_webhook_senders_path
  end
end
