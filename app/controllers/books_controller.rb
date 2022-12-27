class BooksController < ApplicationController
  expose(:book)

  def create
    if book.save
      redirect_to edit_book_path(book)
    else
      flash.alert = book.errors.full_messages
      render :new
    end
  end

  def update
    if book.update(book_params)
      redirect_to edit_book_path(book)
    else
      flash.alert = book.errors.full_messages
      render :edit
    end
  end

  private

  def book_params
    params.require(:book).permit(:finished_on, :isbn)
  end
end
