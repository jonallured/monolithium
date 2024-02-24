require "rails_helper"

describe "Admin views raw hook" do
  include_context "admin password matches"

  scenario "with a valid id" do
    raw_hook = FactoryBot.create(
      :raw_hook,
      body: "please parse me!",
      headers: {"X-Access-Token": "abc123"},
      params: {key: "value"}
    )

    visit "/crud/raw_hooks/#{raw_hook.id}"

    expect(page).to have_content "Raw Hook #{raw_hook.id}"

    expect(page).to have_content "please parse me!"
    expect(page).to have_content "X-Access-Token"
    expect(page).to have_content "abc123"
    expect(page).to have_content "key"
    expect(page).to have_content "value"
  end
end
