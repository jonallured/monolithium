require "rails_helper"

describe "Admin views thing" do
  include_context "admin password matches"

  scenario "from list page" do
    thing = FactoryBot.create(:thing)
    visit "/crud/things"
    click_on thing.id.to_s
    expect(page).to have_css "h1", text: "Thing #{thing.id}"
    expect(page).to have_css "a", text: "Thing List"
    expect(page).to have_current_path crud_thing_path(thing)
  end

  scenario "viewing a record" do
    thing = FactoryBot.create(
      :thing,
      REPLACE_ME: "REPLACE_ME"
    )

    visit "/crud/things/#{thing.id}"

    actual_values = page.all("tr").map do |table_row|
      table_row.all("td").map(&:text)
    end

    expect(actual_values).to eq(
      [
        ["REPLACE_ME", "REPLACE_ME"],
        ["Created At", thing.created_at.to_fs],
        ["Updated At", thing.updated_at.to_fs]
      ]
    )
  end

  scenario "views random record" do
    thing = FactoryBot.create(:thing)
    expect(Thing).to receive(:random).and_return(thing)

    visit "/crud/things"
    click_on "Random Thing"

    expect(page).to have_css "h1", text: "Thing #{thing.id}"
    expect(page).to have_current_path crud_thing_path(thing)
  end
end
