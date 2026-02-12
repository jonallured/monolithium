require "rails_helper"

describe "Admin views boop" do
  include_context "admin password matches"

  scenario "from list page" do
    boop = FactoryBot.create(:boop)
    visit "/crud/boops"
    click_on boop.id.to_s
    expect(page).to have_css "h1", text: "Boop #{boop.id}"
    expect(page).to have_css "a", text: "Boop List"
    expect(page).to have_current_path crud_boop_path(boop)
  end

  scenario "viewing a record" do
    boop = FactoryBot.create(
      :boop,
      number: 1,
      display_type: "skull"
    )

    visit "/crud/boops/#{boop.id}"

    actual_values = page.all("tr").map do |table_row|
      table_row.all("td").map(&:text)
    end

    expect(actual_values).to eq(
      [
        ["Number", "1"],
        ["Display Type", "skull"],
        ["Dismissed At", ""],
        ["Created At", boop.created_at.to_fs],
        ["Updated At", boop.updated_at.to_fs]
      ]
    )
  end

  scenario "views random record" do
    boop = FactoryBot.create(:boop)
    expect(Boop).to receive(:random).and_return(boop)

    visit "/crud/boops"
    click_on "Random Boop"

    expect(page).to have_css "h1", text: "Boop #{boop.id}"
    expect(page).to have_current_path crud_boop_path(boop)
  end
end
