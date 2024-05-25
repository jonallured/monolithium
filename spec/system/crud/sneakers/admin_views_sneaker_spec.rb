require "rails_helper"

describe "Admin views sneaker" do
  include_context "admin password matches"

  scenario "from list page" do
    sneaker = FactoryBot.create(:sneaker)
    visit "/crud/sneakers"
    click_on sneaker.id.to_s
    expect(page).to have_css "h1", text: "Sneaker #{sneaker.id}"
    expect(page).to have_css "a", text: "Sneaker List"
    expect(page).to have_current_path crud_sneaker_path(sneaker)
  end

  scenario "viewing a record" do
    sneaker = FactoryBot.create(
      :sneaker,
      name: "Air Jordan 1",
      details: "Style abc123",
      amount_cents: 10375,
      ordered_on: Time.now
    )

    visit "/crud/sneakers/#{sneaker.id}"

    actual_values = page.all("tr").map do |table_row|
      table_row.all("td").map(&:text)
    end

    expect(actual_values).to eq(
      [
        ["Name", "Air Jordan 1"],
        ["Details", "Style abc123"],
        ["Amount Cents", "10375"],
        ["Ordered On", sneaker.ordered_on.to_fs],
        ["Created At", sneaker.created_at.to_fs],
        ["Updated At", sneaker.updated_at.to_fs]
      ]
    )
  end

  scenario "views random record" do
    sneaker = FactoryBot.create(:sneaker)
    expect(Sneaker).to receive(:random).and_return(sneaker)

    visit "/crud/sneakers"
    click_on "Random Sneaker"

    expect(page).to have_css "h1", text: "Sneaker #{sneaker.id}"
    expect(page).to have_current_path crud_sneaker_path(sneaker)
  end
end
