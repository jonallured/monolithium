require "rails_helper"

describe "User views reading list" do
  include_context "session password matches"

  before do
    allow(OpenLibrary).to receive(:get_book).and_return(nil)
  end

  scenario "with no books" do
    visit "/reading-list/#{Time.now.year}"
    book_rows = page.all("tbody tr")
    expect(book_rows.count).to eq 0
  end

  scenario "with a few books" do
    FactoryBot.create_list :book, 3
    visit "/reading-list/#{Time.now.year}"
    book_rows = page.all("tbody tr")
    expect(book_rows.count).to eq 3
  end

  scenario "with a book from another year" do
    FactoryBot.create :book, finished_on: Time.now - 1.year
    visit "/reading-list/#{Time.now.year}"
    book_rows = page.all("tbody tr")
    expect(book_rows.count).to eq 0
  end
end
