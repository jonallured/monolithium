require "rails_helper"

describe "Admin edits book" do
  include_context "admin password matches"

  scenario "from show page" do
    book = FactoryBot.create(:book)
    visit "/crud/books/#{book.id}"
    click_on "Edit Book"
    expect(page).to have_css "h1", text: "Edit Book #{book.id}"
    expect(page).to have_css "a", text: "Show Book"
    expect(page).to have_current_path edit_crud_book_path(book)
  end

  scenario "edit with errors" do
    book = FactoryBot.create(:book)
    visit "/crud/books/#{book.id}/edit"
    fill_in "isbn", with: ""
    click_on "update"
    expect(page).to have_css ".alert", text: "Isbn can't be blank"
  end

  scenario "edit successfully" do
    book = FactoryBot.create(
      :book,
      title: "Whiddling And You"
    )
    visit "/crud/books/#{book.id}/edit"
    fill_in "title", with: "Whittling And You"
    click_on "update"

    expect(page).to have_css ".notice", text: "Book updated"
    expect(page).to have_current_path crud_book_path(book)
    expect(page).to have_css "td", text: "Whittling And You"
  end
end
