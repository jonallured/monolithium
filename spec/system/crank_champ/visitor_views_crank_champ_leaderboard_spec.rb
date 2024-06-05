require "rails_helper"

describe "Visitor views crank champ leaderboard" do
  scenario "with no crank counts" do
    visit "/crank-champ/leaderboard"
    expect(page).to have_css "h1", text: "Crank Champ Leaderboard"
    expect(page).to have_css "p", text: "no crank counts yet!"
  end

  scenario "with a few crank counts" do
    second_place_user = FactoryBot.create(:crank_user)
    last_place_user = FactoryBot.create(:crank_user)
    first_place_user = FactoryBot.create(:crank_user)

    FactoryBot.create(:crank_count, crank_user: second_place_user, ticks: 50)
    FactoryBot.create(:crank_count, crank_user: last_place_user, ticks: 1)
    FactoryBot.create(:crank_count, crank_user: first_place_user, ticks: 100)

    visit "/crank-champ/leaderboard"

    actual_row_data = page.all("tbody tr").map do |row|
      user_code_cell, crank_count_cell, *_rest = row.all("td")
      [user_code_cell, crank_count_cell].map(&:text)
    end

    expect(actual_row_data).to eq([
      [first_place_user.code, "100"],
      [second_place_user.code, "50"],
      [last_place_user.code, "1"]
    ])
  end
end
