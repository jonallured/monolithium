require "rails_helper"

describe "Admin views Cybertail page", js: true do
  include_context "admin password matches"

  scenario "new hook shows up after existing one" do
    mock_parser = Class.new do
      def self.check_and_maybe_parse(raw_hook)
        raw_hook.create_hook(
          message: raw_hook.body,
          webhook_sender: WebhookSender.first
        )
      end
    end
    stub_const "MockParser", mock_parser

    FactoryBot.create(:webhook_sender, parser: "MockParser")

    perform_enqueued_jobs do
      FactoryBot.create(:raw_hook, body: "first one")
    end

    visit "/cybertail"

    expect(page).to have_css "li", text: "first one"
    expect(page.all("li").count).to eq 1

    perform_enqueued_jobs do
      FactoryBot.create(:raw_hook, body: "second one")
    end

    expect(page).to have_css "li", text: "second one"
    expect(page.all("li").count).to eq 2
  end
end
