require "rails_helper"

describe "Admin views warm fuzzy" do
  include_context "admin password matches"

  scenario "from list page" do
    warm_fuzzy = FactoryBot.create(:warm_fuzzy)
    visit "/crud/warm_fuzzies"
    click_on warm_fuzzy.id.to_s
    expect(page).to have_css "h1", text: "Warm Fuzzy #{warm_fuzzy.id}"
    expect(page).to have_css "a", text: "Warm Fuzzy List"
    expect(page).to have_current_path crud_warm_fuzzy_path(warm_fuzzy)
  end

  scenario "viewing a record" do
    warm_fuzzy = FactoryBot.create(
      :warm_fuzzy,
      title: "Very Nice Code",
      author: "Secret Admirer",
      body: "Jon is great at making very nice code!",
      received_at: Time.now
    )

    visit "/crud/warm_fuzzies/#{warm_fuzzy.id}"

    actual_values = page.all("tr").map do |table_row|
      table_row.all("td").map(&:text)
    end

    expect(actual_values).to eq(
      [
        ["Title", "Very Nice Code"],
        ["Author", "Secret Admirer"],
        ["Body", "Jon is great at making very nice code!"],
        ["Received At", warm_fuzzy.received_at.to_fs],
        ["Created At", warm_fuzzy.created_at.to_fs],
        ["Updated At", warm_fuzzy.updated_at.to_fs]
      ]
    )
  end

  scenario "views random record" do
    warm_fuzzy = FactoryBot.create(:warm_fuzzy)
    expect(WarmFuzzy).to receive(:random).and_return(warm_fuzzy)

    visit "/crud/warm_fuzzies"
    click_on "Random Warm Fuzzy"

    expect(page).to have_css "h1", text: "Warm Fuzzy #{warm_fuzzy.id}"
    expect(page).to have_current_path crud_warm_fuzzy_path(warm_fuzzy)
  end
end
