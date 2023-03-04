class Book < ApplicationRecord
  validates :isbn, presence: true
  validates :finished_on, presence: true

  after_create :enqueue_enhance

  def enhance!
    open_data = OpenLibrary.get_book(isbn)
    return unless open_data

    open_attrs = {
      isbn: open_data["isbn_13"].first,
      pages: open_data["number_of_pages"],
      title: open_data["title"]
    }
    update!(open_attrs)
  end

  private

  def enqueue_enhance
    EnhanceBookJob.perform_later(id)
  end
end
