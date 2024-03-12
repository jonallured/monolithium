require "rails_helper"

describe "Admin creates book" do
  include_context "admin password matches"

  scenario "creating first book" do
    visit "/crud/books/new"
    fill_in "book[isbn]", with: "abc-123"
    fill_in "book[finished_on]", with: "01/01/2000"
    click_on "create"

    expect(page).to have_css ".notice", text: "Book created"

    book = Book.last

    actual_values = page.all("tr").map do |table_row|
      table_row.all("td").map(&:text)
    end

    expect(actual_values).to eq(
      [
        ["ISBN", "abc-123"],
        ["Title", ""],
        ["Pages", ""],
        ["Finished On", book.finished_on.to_formatted_s(:long)],
        ["Created At", book.created_at.to_formatted_s(:long)],
        ["Updated At", book.updated_at.to_formatted_s(:long)]
      ]
    )
  end
end
