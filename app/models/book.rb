class Book < ApplicationRecord
  validates :isbn, presence: true
  validates :finished_on, presence: true

  def enhance!
    open_data = OpenLibraryApi.get_book(isbn)
    return unless open_data

    open_attrs = {
      isbn: open_data["isbn_13"].first,
      pages: open_data["number_of_pages"],
      title: open_data["title"]
    }
    update!(open_attrs)
  end

  def table_attrs
    [
      ["ISBN", isbn],
      ["Title", title],
      ["Pages", pages],
      ["Finished On", finished_on.to_formatted_s(:long)],
      ["Created At", created_at.to_formatted_s(:long)],
      ["Updated At", updated_at.to_formatted_s(:long)]
    ]
  end
end
