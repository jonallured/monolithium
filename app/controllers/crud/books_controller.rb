class Crud::BooksController < ApplicationController
  expose(:book)
  expose(:books) do
    Book.order(created_at: :desc).page(params[:page])
  end

  def show
    redirect_to crud_book_path(Book.random) if random_id?
  end

  def create
    if book.save
      EnhanceBookJob.perform_later(book.id)
      flash.notice = "Book created"
      redirect_to crud_book_path(book)
    else
      flash.alert = book.errors.full_messages.to_sentence
      redirect_to new_crud_book_path
    end
  end

  def update
    if book.update(book_params)
      flash.notice = "Book updated"
      redirect_to crud_book_path(book)
    else
      flash.alert = book.errors.full_messages.to_sentence
      redirect_to edit_crud_book_path(book)
    end
  end

  def destroy
    book.destroy
    flash.notice = "Book deleted"
    redirect_to crud_books_path
  end

  private

  def book_params
    params.require(:book).permit(Book.permitted_params)
  end
end
