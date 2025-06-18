module Api
  module V1
    class BooksController < Api::V1Controller
      expose(:book, with: :random_or_find)

      expose(:books) do
        Book.order(created_at: :desc).page(params[:page])
      end

      def create
        book.save!
        EnhanceBookJob.perform_later(book.id)
        render :show, status: :created
      end

      def update
        book.update!(book_params)
        render :show
      end

      def destroy
        book.destroy
        head :ok
      end

      private

      def book_params
        params.require(:book).permit(:finished_on, :format, :isbn, :pages, :title)
      end
    end
  end
end
