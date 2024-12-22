class Book::Enhancer < ActiveRecord::AssociatedObject
  def update_from_api
    return if book.isbn == "none"

    api_data = OpenLibraryApi.get_book(book.isbn)
    return unless api_data

    isbns = api_data["isbn_13"] || []

    attrs = {
      isbn: isbns.first,
      pages: api_data["number_of_pages"],
      title: api_data["title"]
    }.compact
    return unless attrs.any?

    book.update!(attrs)
  end
end
