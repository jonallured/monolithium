require "rails_helper"

describe "Admin deletes book" do
  include_context "admin password matches"

  let(:book) { FactoryBot.create(:book) }

  scenario "cancels delete" do
    visit "/crud/books/#{book.id}"

    dismiss_confirm { click_on "Delete Book" }

    expect(Book.count).to eq 1
    expect(page).to have_current_path crud_book_path(book)
  end

  scenario "confirms delete" do
    visit "/crud/books/#{book.id}"

    accept_confirm { click_on "Delete Book" }

    expect(page).to have_css ".notice", text: "Book deleted"

    expect(Book.count).to eq 0
    expect(page).to have_current_path crud_books_path
  end
end
