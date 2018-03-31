class WorkWeek
  class InvalidDates < StandardError; end

  attr_reader :work_days

  def self.find_or_create_by(year:, number:)
    work_week = new(year, number)
    work_week.find_or_create
    work_week
  rescue InvalidDates # rubocop:disable Lint/HandleExceptions
    # year and/or number failed to parse as valid date
  end

  def initialize(year, number)
    @year = year.to_i
    @number = number.to_i
  end

  def find_or_create
    @work_days = dates.map do |date|
      WorkDay.find_or_create_by!(date: date)
    end
  end

  private

  def dates
    raise InvalidDates unless @year.positive? && @number.positive?
    (1..5).map { |day| Date.commercial(@year, @number, day) }
  rescue StandardError
    raise InvalidDates
  end
end
