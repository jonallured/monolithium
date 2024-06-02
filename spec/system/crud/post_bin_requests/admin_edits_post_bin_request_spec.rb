require "rails_helper"

describe "Admin edits post bin request" do
  include_context "admin password matches"

  scenario "from show page" do
    post_bin_request = FactoryBot.create(:post_bin_request)
    visit "/crud/post_bin_requests/#{post_bin_request.id}"
    click_on "Edit Post Bin Request"
    expect(page).to have_css "h1", text: "Edit Post Bin Request #{post_bin_request.id}"
    expect(page).to have_css "a", text: "Show Post Bin Request"
    expect(page).to have_current_path edit_crud_post_bin_request_path(post_bin_request)
  end

  scenario "edit successfully" do
    post_bin_request = FactoryBot.create(
      :post_bin_request,
      body: "very lame bayload"
    )
    visit "/crud/post_bin_requests/#{post_bin_request.id}/edit"
    fill_in "body", with: "very cool payload"
    click_on "update"

    expect(page).to have_css ".notice", text: "Post Bin Request updated"
    expect(page).to have_current_path crud_post_bin_request_path(post_bin_request)
    expect(page).to have_css "pre code", text: "very cool payload"
  end
end
