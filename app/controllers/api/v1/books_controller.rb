module Api
  module V1
    class BooksController < Api::V1Controller
      expose(:book, with: :random_or_find)

      expose(:books) do
        Book.order(created_at: :desc).page(params[:page])
      end
    end
  end
end
