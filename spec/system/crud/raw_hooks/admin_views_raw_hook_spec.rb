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

    expect(page).to have_css "h1", text: "Raw Hook #{raw_hook.id}"

    headers_code_tag, params_code_tag, body_code_tag = page.all("code")
    expect(headers_code_tag.text).to include "X-Access-Token"
    expect(headers_code_tag.text).to include "abc123"
    expect(params_code_tag.text).to include "key"
    expect(params_code_tag.text).to include "value"
    expect(body_code_tag.text).to include "please parse me!"
  end
end
