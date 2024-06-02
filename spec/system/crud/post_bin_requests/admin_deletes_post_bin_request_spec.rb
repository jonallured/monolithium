require "rails_helper"

describe "Admin deletes post bin request" do
  include_context "admin password matches"

  let(:post_bin_request) { FactoryBot.create(:post_bin_request) }

  scenario "cancels delete" do
    visit "/crud/post_bin_requests/#{post_bin_request.id}"

    dismiss_confirm { click_on "Delete Post Bin Request" }

    expect(PostBinRequest.count).to eq 1
    expect(page).to have_current_path crud_post_bin_request_path(post_bin_request)
  end

  scenario "confirms delete" do
    visit "/crud/post_bin_requests/#{post_bin_request.id}"

    accept_confirm { click_on "Delete Post Bin Request" }

    expect(page).to have_css ".notice", text: "Post Bin Request deleted"

    expect(PostBinRequest.count).to eq 0
    expect(page).to have_current_path crud_post_bin_requests_path
  end
end
