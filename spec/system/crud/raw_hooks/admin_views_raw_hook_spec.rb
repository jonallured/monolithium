require "rails_helper"

describe "Admin views raw hook" do
  include_context "admin password matches"

  scenario "from list page" do
    raw_hook = FactoryBot.create(:raw_hook)
    visit "/crud/raw_hooks"
    click_on raw_hook.id.to_s
    expect(page).to have_css "h1", text: "Raw Hook #{raw_hook.id}"
    expect(page).to have_css "a", text: "Raw Hook List"
    expect(page).to have_current_path crud_raw_hook_path(raw_hook)
  end

  scenario "viewing a record" do
    raw_hook = FactoryBot.create(
      :raw_hook,
      body: "payload",
      headers: {"x-header-name" => "header-value"}.to_json,
      params: {"param-name" => "param-value"}.to_json
    )

    visit "/crud/raw_hooks/#{raw_hook.id}"

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

  scenario "views random record" do
    raw_hook = FactoryBot.create(:raw_hook)
    expect(RawHook).to receive(:random).and_return(raw_hook)

    visit "/crud/raw_hooks"
    click_on "Random Raw Hook"

    expect(page).to have_css "h1", text: "Raw Hook #{raw_hook.id}"
    expect(page).to have_current_path crud_raw_hook_path(raw_hook)
  end
end
