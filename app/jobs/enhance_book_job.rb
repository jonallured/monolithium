class EnhanceBookJob < ApplicationJob
  def perform(book_id)
    book = Book.find_by(id: book_id)
    return unless book

    book.enhancer.update_from_api
  end
end
