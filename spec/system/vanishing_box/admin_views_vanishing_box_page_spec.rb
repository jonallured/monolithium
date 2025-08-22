require "rails_helper"

describe "Admin views Vanishing Box page", js: true do
  include_context "admin password matches"

  scenario "new message shows up" do
    visit "/vanishing-box"

    expect(page.all("section p").count).to eq 0
    expect(page.all("section pre").count).to eq 0

    fill_in :body, with: "top secret message!"
    click_on "Add"

    expect(page.all("section p").count).to eq 1
    expect(page).to have_css "section pre", text: "top secret message!"
  end
end
