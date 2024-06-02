require "rails_helper"

describe "Admin creates post bin request" do
  include_context "admin password matches"

  scenario "from list page" do
    visit "/crud/post_bin_requests"
    click_on "New Post Bin Request"
    expect(page).to have_css "h1", text: "New Post Bin Request"
    expect(page).to have_css "a", text: "Post Bin Request List"
    expect(page).to have_current_path new_crud_post_bin_request_path
  end

  scenario "create successfully" do
    visit "/crud/post_bin_requests/new"
    fill_in "body", with: "payload"
    fill_in "headers", with: {"x-header-name" => "header-value"}.to_json
    fill_in "params", with: {"param-name" => "param-value"}.to_json
    click_on "create"

    expect(page).to have_css ".notice", text: "Post Bin Request created"

    post_bin_request = PostBinRequest.last
    expect(page).to have_current_path crud_post_bin_request_path(post_bin_request)

    actual_values = page.all("tr").map do |table_row|
      table_row.all("td").map(&:text)
    end

    expect(actual_values).to eq(
      [
        ["Created At", post_bin_request.created_at.to_fs],
        ["Updated At", post_bin_request.updated_at.to_fs]
      ]
    )

    expect(page.all("h2").map(&:text)).to eq %w[Headers Params Body]
    expect(page.all("pre code").map(&:text)).to eq(
      [
        JSON.pretty_generate(post_bin_request.headers),
        JSON.pretty_generate(post_bin_request.params),
        post_bin_request.body
      ]
    )
  end
end
