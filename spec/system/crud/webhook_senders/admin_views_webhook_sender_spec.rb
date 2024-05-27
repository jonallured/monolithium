require "rails_helper"

describe "Admin views webhook sender" do
  include_context "admin password matches"

  scenario "from list page" do
    webhook_sender = FactoryBot.create(:webhook_sender)
    visit "/crud/webhook_senders"
    click_on webhook_sender.id.to_s
    expect(page).to have_css "h1", text: "Webhook Sender #{webhook_sender.id}"
    expect(page).to have_css "a", text: "Webhook Sender List"
    expect(page).to have_current_path crud_webhook_sender_path(webhook_sender)
  end

  scenario "viewing a record" do
    webhook_sender = FactoryBot.create(
      :webhook_sender,
      name: "Chatty Service",
      parser: "ChattyServiceParser"
    )

    visit "/crud/webhook_senders/#{webhook_sender.id}"

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

  scenario "views random record" do
    webhook_sender = FactoryBot.create(:webhook_sender)
    expect(WebhookSender).to receive(:random).and_return(webhook_sender)

    visit "/crud/webhook_senders"
    click_on "Random Webhook Sender"

    expect(page).to have_css "h1", text: "Webhook Sender #{webhook_sender.id}"
    expect(page).to have_current_path crud_webhook_sender_path(webhook_sender)
  end
end
