class ReadingListController < ApplicationController
  expose(:year) { params[:year] }

  expose(:books) do
    start_finished = DateTime.parse("#{year}-01-01")
    stop_finished = start_finished.end_of_year

    Book
      .where(finished_on: start_finished..stop_finished)
      .order(finished_on: :asc, pages: :desc)
  end

  expose(:total_pages) { books.pluck(:pages).compact.sum }

  expose(:pace) do
    days_so_far = Time.zone.today.mjd - Time.zone.today.beginning_of_year.mjd
    exact_pace = (total_pages * 1.0) / days_so_far
    exact_pace.round(2)
  end
end
