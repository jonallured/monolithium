class EnhanceBookJob < ApplicationJob
  def perform(book_id)
    book = Book.find(book_id)
    return unless book

    book.enhance!
  end
end
