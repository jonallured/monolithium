require "rails_helper"

describe "Admin views post bin request" do
  include_context "admin password matches"

  scenario "from list page" do
    post_bin_request = FactoryBot.create(:post_bin_request)
    visit "/crud/post_bin_requests"
    click_on post_bin_request.id.to_s
    expect(page).to have_css "h1", text: "Post Bin Request #{post_bin_request.id}"
    expect(page).to have_css "a", text: "Post Bin Request List"
    expect(page).to have_current_path crud_post_bin_request_path(post_bin_request)
  end

  scenario "viewing a record" do
    post_bin_request = FactoryBot.create(
      :post_bin_request,
      body: "payload",
      headers: {"x-header-name" => "header-value"}.to_json,
      params: {"param-name" => "param-value"}.to_json
    )

    visit "/crud/post_bin_requests/#{post_bin_request.id}"

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

  scenario "views random record" do
    post_bin_request = FactoryBot.create(:post_bin_request)
    expect(PostBinRequest).to receive(:random).and_return(post_bin_request)

    visit "/crud/post_bin_requests"
    click_on "Random Post Bin Request"

    expect(page).to have_css "h1", text: "Post Bin Request #{post_bin_request.id}"
    expect(page).to have_current_path crud_post_bin_request_path(post_bin_request)
  end
end
