class Book < ApplicationRecord
  validates :isbn, presence: true
  validates :finished_on, presence: true

  def enhance!
    return if isbn == "none"

    open_data = OpenLibraryApi.get_book(isbn)
    return unless open_data.is_a? Hash

    isbns = open_data["isbn_13"] || []

    open_attrs = {
      isbn: isbns.first,
      pages: open_data["number_of_pages"],
      title: open_data["title"]
    }.compact

    return unless open_attrs.any?

    update!(open_attrs)
  end

  def table_attrs
    [
      ["ISBN", isbn],
      ["Title", title],
      ["Pages", pages],
      ["Finished On", finished_on.to_fs],
      ["Created At", created_at.to_fs],
      ["Updated At", updated_at.to_fs]
    ]
  end
end
