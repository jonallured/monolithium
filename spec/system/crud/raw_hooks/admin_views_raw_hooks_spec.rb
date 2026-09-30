require "rails_helper"

describe "Admin views raw hooks" do
  include_context "admin password matches"

  scenario "from dashboard" do
    visit "/dashboard"
    click_on "Raw Hooks"
    expect(page).to have_css "h1", text: "Raw Hooks"
    expect(page).to have_current_path crud_raw_hooks_path
  end

  scenario "with no records" do
    visit "/crud/raw_hooks"
    expect(page.all("tbody tr").count).to eq 0
  end

  scenario "with a record that has a long body" do
    raw_hook = FactoryBot.create(
      :raw_hook,
      body: "This body is so long that it would cause rendering issues and what I'd rather see is it cut off at one hundred characters right here"
    )
    visit "/crud/raw_hooks"
    body_cell = page.all("tbody td")[1].text
    expect(body_cell).to eq raw_hook.body.truncate(100)
  end

  scenario "with a page of records" do
    FactoryBot.create_list(:raw_hook, 3)
    visit "/crud/raw_hooks"
    expect(page.all("tbody tr").count).to eq 3
    expect(page).to_not have_css "nav.pagination"
  end

  scenario "with two pages of records" do
    FactoryBot.create_list(:raw_hook, 4)
    visit "/crud/raw_hooks"
    expect(page.all("tbody tr").count).to eq 3
    expect(page).to have_css "nav.pagination"
  end
end
