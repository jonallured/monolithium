require "rails_helper"

describe "Admin creates book" do
  include_context "admin password matches"

  scenario "from list page" do
    visit "/crud/books"
    click_on "New Book"
    expect(page).to have_css "h1", text: "New Book"
    expect(page).to have_css "a", text: "Book List"
    expect(page).to have_current_path new_crud_book_path
  end

  scenario "create with errors" do
    visit "/crud/books/new"
    click_on "create"
    expect(page).to have_css ".alert", text: "Finished on can't be blank, Format is not included in the list, and Isbn can't be blank"
    expect(page).to have_current_path new_crud_book_path
  end

  scenario "create successfully" do
    visit "/crud/books/new"
    fill_in "isbn", with: "abc-123"
    select "print", from: "book_format"
    fill_in "finished on", with: "01/01/2000"
    click_on "create"

    expect(page).to have_css ".notice", text: "Book created"

    book = Book.last
    expect(page).to have_current_path crud_book_path(book)

    expect(EnhanceBookJob).to have_been_enqueued.with(book.id)

    actual_values = page.all("tr").map do |table_row|
      table_row.all("td").map(&:text)
    end

    expect(actual_values).to eq(
      [
        ["ISBN", "abc-123"],
        ["Title", ""],
        ["Pages", ""],
        ["Format", "print"],
        ["Finished On", "01/01/2000"],
        ["Created At", book.created_at.to_fs],
        ["Updated At", book.updated_at.to_fs]
      ]
    )
  end
end
