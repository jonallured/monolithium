require "rails_helper"

describe "Admin creates raw hook" do
  include_context "admin password matches"

  scenario "from list page" do
    visit "/crud/raw_hooks"
    click_on "New Raw Hook"
    expect(page).to have_css "h1", text: "New Raw Hook"
    expect(page).to have_css "a", text: "Raw Hook List"
    expect(page).to have_current_path new_crud_raw_hook_path
  end

  scenario "create with errors" do
    visit "/crud/raw_hooks/new"
    click_on "create"
    expect(page).to have_css ".alert", text: "Body can't be blank, Headers can't be blank, and Params can't be blank"
    expect(page).to have_current_path new_crud_raw_hook_path
  end

  scenario "create successfully" do
    visit "/crud/raw_hooks/new"
    fill_in "body", with: "payload"
    fill_in "headers", with: {"x-header-name" => "header-value"}.to_json
    fill_in "params", with: {"param-name" => "param-value"}.to_json
    click_on "create"

    expect(page).to have_css ".notice", text: "Raw Hook created"

    raw_hook = RawHook.last
    expect(page).to have_current_path crud_raw_hook_path(raw_hook)

    actual_values = page.all("tr").map do |table_row|
      table_row.all("td").map(&:text)
    end

    expect(actual_values).to eq(
      [
        ["Created At", raw_hook.created_at.to_fs],
        ["Updated At", raw_hook.updated_at.to_fs]
      ]
    )

    expect(page.all("h2").map(&:text)).to eq %w[Headers Params Body]
    expect(page.all("pre code").map(&:text)).to eq(
      [
        JSON.pretty_generate(raw_hook.headers),
        JSON.pretty_generate(raw_hook.params),
        raw_hook.body
      ]
    )
  end
end
