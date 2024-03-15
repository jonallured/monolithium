require "rails_helper"

describe "Admin views fuzzies" do
  include_context "admin password matches"

  scenario "from dashboard" do
    visit "/dashboard"
    click_on "Fuzzies"
    expect(page).to have_css "h1", text: "Fuzzies"
    expect(page).to have_current_path fuzzies_path
  end

  scenario "with some records" do
    warm_fuzzies = FactoryBot.create_list(:warm_fuzzy, 3)
    visit "/fuzzies"
    warm_fuzzies.each do |warm_fuzzy|
      expect(page).to have_css "h2", text: warm_fuzzy.title
      expect(page).to have_content warm_fuzzy.author
      expect(page).to have_content warm_fuzzy.received_at.to_fs
      expect(page).to have_css "blockquote", text: warm_fuzzy.body
    end
  end
end
