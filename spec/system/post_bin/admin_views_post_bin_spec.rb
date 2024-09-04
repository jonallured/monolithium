require "rails_helper"

describe "Admin views post bin", js: true do
  include_context "admin password matches"

  scenario "with an initial post bin request and then another is created" do
    first_one = FactoryBot.create(:post_bin_request, body: "first one")

    visit "/post_bin"

    expect(page).to have_css "li a", text: "#{first_one.id} first one"
    expect(page.all("li").count).to eq 1

    perform_enqueued_jobs do
      second_one = FactoryBot.create(:post_bin_request, body: "")

      expect(page).to have_css "li a", text: second_one.id
      expect(page.all("li").count).to eq 2
    end
  end
end
