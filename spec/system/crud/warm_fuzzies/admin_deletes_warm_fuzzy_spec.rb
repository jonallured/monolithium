require "rails_helper"

describe "Admin deletes warm fuzzy" do
  include_context "admin password matches"

  let(:warm_fuzzy) { FactoryBot.create(:warm_fuzzy) }

  scenario "cancels delete", js: true do
    visit "/crud/warm_fuzzies/#{warm_fuzzy.id}"

    dismiss_confirm { click_on "Delete Warm Fuzzy" }

    expect(WarmFuzzy.count).to eq 1
    expect(page).to have_current_path crud_warm_fuzzy_path(warm_fuzzy)
  end

  scenario "confirms delete", js: true do
    visit "/crud/warm_fuzzies/#{warm_fuzzy.id}"

    accept_confirm { click_on "Delete Warm Fuzzy" }

    expect(page).to have_css ".notice", text: "Warm Fuzzy deleted"

    expect(WarmFuzzy.count).to eq 0
    expect(page).to have_current_path crud_warm_fuzzies_path
  end
end
