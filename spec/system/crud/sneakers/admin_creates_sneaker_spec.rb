require "rails_helper"

describe "Admin creates sneaker" do
  include_context "admin password matches"

  scenario "from list page" do
    visit "/crud/sneakers"
    click_on "New Sneaker"
    expect(page).to have_css "h1", text: "New Sneaker"
    expect(page).to have_css "a", text: "Sneaker List"
    expect(page).to have_current_path new_crud_sneaker_path
  end

  scenario "create with errors" do
    visit "/crud/sneakers/new"
    click_on "create"
    expect(page).to have_css ".alert", text: "Amount cents can't be blank, Details can't be blank, Name can't be blank, and Ordered on can't be blank"
    expect(page).to have_current_path new_crud_sneaker_path
  end

  scenario "create successfully" do
    visit "/crud/sneakers/new"
    fill_in "name", with: "Air Jordan 1"
    fill_in "details", with: "Style abc123"
    fill_in "amount cents", with: "10375"
    fill_in "ordered on", with: "01/01/2000"
    click_on "create"

    expect(page).to have_css ".notice", text: "Sneaker created"

    sneaker = Sneaker.last
    expect(page).to have_current_path crud_sneaker_path(sneaker)

    actual_values = page.all("tr").map do |table_row|
      table_row.all("td").map(&:text)
    end

    expect(actual_values).to eq(
      [
        ["Name", "Air Jordan 1"],
        ["Details", "Style abc123"],
        ["Amount Cents", "10375"],
        ["Ordered On", "01/01/2000"],
        ["Created At", sneaker.created_at.to_fs],
        ["Updated At", sneaker.updated_at.to_fs]
      ]
    )
  end

  scenario "create successfully with image" do
    visit "/crud/sneakers/new"
    fill_in "name", with: "Air Jordan 1"
    fill_in "details", with: "Style abc123"
    fill_in "amount cents", with: "10375"
    attach_file "image", "spec/testing_files/pizza.png"
    fill_in "ordered on", with: "01/01/2000"
    click_on "create"

    expect(page).to have_css ".notice", text: "Sneaker created"
    expect(page).to have_css "h2", text: "Image"
    expect(page.all("main img").count).to eq 1
  end
end
