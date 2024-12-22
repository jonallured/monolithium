require "rails_helper"

describe "Admin views book" do
  include_context "admin password matches"

  scenario "from list page" do
    book = FactoryBot.create(:book)
    visit "/crud/books"
    click_on book.id.to_s
    expect(page).to have_css "h1", text: "Book #{book.id}"
    expect(page).to have_css "a", text: "Book List"
    expect(page).to have_current_path crud_book_path(book)
  end

  scenario "viewing a record" do
    book = FactoryBot.create(
      :book,
      finished_on: Date.today,
      isbn: "abc-123",
      pages: 777,
      title: "Whittling And You"
    )

    visit "/crud/books/#{book.id}"

    actual_values = page.all("tr").map do |table_row|
      table_row.all("td").map(&:text)
    end

    expect(actual_values).to eq(
      [
        ["ISBN", "abc-123"],
        ["Title", "Whittling And You"],
        ["Pages", "777"],
        ["Format", "print"],
        ["Finished On", book.finished_on.to_fs],
        ["Created At", book.created_at.to_fs],
        ["Updated At", book.updated_at.to_fs]
      ]
    )
  end

  scenario "views random record" do
    book = FactoryBot.create(:book)
    expect(Book).to receive(:random).and_return(book)

    visit "/crud/books"
    click_on "Random Book"

    expect(page).to have_css "h1", text: "Book #{book.id}"
    expect(page).to have_current_path crud_book_path(book)
  end
end
