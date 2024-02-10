require "rails_helper"

describe "Admin creates book" do
  include_context "admin password matches"

  scenario "creating first book" do
    visit "/admin/books/new"
    fill_in "book[isbn]", with: "123"
    fill_in "book[finished_on]", with: "01/01/2000"
    click_on "create"

    actual_values = page.all("dl div").map do |div|
      [div.find("dt").text, div.find("dd").text]
    end

    expect(actual_values).to eq(
      [
        ["ISBN", "123"],
        ["Finished On", "2000-01-01"],
        ["Title", ""],
        ["Pages", ""]
      ]
    )
  end
end
