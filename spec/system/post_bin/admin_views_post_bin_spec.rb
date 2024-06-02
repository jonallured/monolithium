require "rails_helper"

describe "Admin views post bin", js: true do
  include_context "admin password matches"

  scenario "with an initial post bin request and then another is created" do
    FactoryBot.create(:post_bin_request, body: "first one")

    visit "/post_bin"

    expect(page).to have_css "li a", text: "first one"
    expect(page.all("li").count).to eq 1

    perform_enqueued_jobs do
      FactoryBot.create(:post_bin_request, body: "second one")
    end

    expect(page).to have_css "li a", text: "second one"
    expect(page.all("li").count).to eq 2
  end
end
