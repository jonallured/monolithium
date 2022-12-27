class BookListController < ApplicationController
  expose(:year) { params[:year] }
  expose(:books) { Book.all.order(finished_on: :asc, pages: :desc) }
  expose(:total_pages) { books.pluck(:pages).compact.sum }
  expose(:pace) do
    days_so_far = Time.zone.today.mjd - Time.zone.today.beginning_of_year.mjd
    exact_pace = (total_pages * 1.0) / days_so_far
    exact_pace.round(2)
  end
end
