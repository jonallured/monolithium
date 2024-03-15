require "rails_helper"

describe "Admin creates warm fuzzy" do
  include_context "admin password matches"

  scenario "from list page" do
    visit "/crud/warm_fuzzies"
    click_on "New Warm Fuzzy"
    expect(page).to have_css "h1", text: "New Warm Fuzzy"
    expect(page).to have_css "a", text: "Warm Fuzzy List"
    expect(page).to have_current_path new_crud_warm_fuzzy_path
  end

  scenario "create with errors" do
    visit "/crud/warm_fuzzies/new"
    click_on "create"
    expect(page).to have_css ".alert", text: "Author can't be blank, Received at can't be blank, and Title can't be blank"
    expect(page).to have_current_path new_crud_warm_fuzzy_path
  end

  scenario "create successfully" do
    visit "/crud/warm_fuzzies/new"
    fill_in "title", with: "Very Nice Code"
    fill_in "author", with: "Secret Admirer"
    fill_in "body", with: "Jon is great at making very nice code!"
    fill_in "received at", with: "01/01/2000\t01:01am"
    click_on "create"

    expect(page).to have_css ".notice", text: "Warm Fuzzy created"

    warm_fuzzy = WarmFuzzy.last
    expect(page).to have_current_path crud_warm_fuzzy_path(warm_fuzzy)

    actual_values = page.all("tr").map do |table_row|
      table_row.all("td").map(&:text)
    end

    expect(actual_values).to eq(
      [
        ["Title", "Very Nice Code"],
        ["Author", "Secret Admirer"],
        ["Body", "Jon is great at making very nice code!"],
        ["Received At", "01/01/2000 01:01:00am"],
        ["Created At", warm_fuzzy.created_at.to_fs],
        ["Updated At", warm_fuzzy.updated_at.to_fs]
      ]
    )
  end

  scenario "create successfully with screenshot" do
    visit "/crud/warm_fuzzies/new"
    fill_in "title", with: "Very Nice Code"
    fill_in "author", with: "Secret Admirer"
    attach_file "screenshot", "spec/testing_files/pizza.png"
    fill_in "received at", with: "01/01/2000\t01:01am"
    click_on "create"

    expect(page).to have_css ".notice", text: "Warm Fuzzy created"
    expect(page).to have_css "h2", text: "Screenshot"
    expect(page.all("main img").count).to eq 1
  end
end
