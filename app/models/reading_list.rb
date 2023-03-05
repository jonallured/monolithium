class ReadingList
  attr_reader :year

  def initialize(year = Time.now.year)
    @year = year
  end

  def books
    @books ||= select_books
  end

  def total_pages
    books.pluck(:pages).compact.sum
  end

  def pace
    return if Time.now.year < @year

    exact_pace = (total_pages * 1.0) / days_so_far
    exact_pace.round(2)
  end

  private

  def select_books
    start_finished = DateTime.parse("#{@year}-01-01")
    stop_finished = start_finished.end_of_year

    Book
      .where(finished_on: start_finished..stop_finished)
      .order(finished_on: :asc, pages: :desc)
  end

  def days_so_far
    return 365 if Time.now.year > @year

    Time.zone.today.mjd - Time.zone.today.beginning_of_year.mjd
  end
end
