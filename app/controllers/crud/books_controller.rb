class Crud::BooksController < ApplicationController
  expose(:book)
  expose(:books) do
    Book.order(created_at: :desc).page(params[:page])
  end

  def show
    redirect_to crud_book_path(Book.random) if params[:id] == "random"
  end

  def create
    if book.save
      EnhanceBookJob.perform_later(book.id)
      flash.notice = "Book created"
      redirect_to crud_book_path(book)
    else
      flash.alert = book.errors.full_messages
      render :new
    end
  end

  def update
    if book.update(book_params)
      redirect_to edit_crud_book_path(book)
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
