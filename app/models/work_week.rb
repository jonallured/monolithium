class WorkWeek
  class InvalidDates < StandardError; end

  attr_accessor :work_days

  def self.find_or_create(year, number)
    work_week = new(year, number)
    work_week.find_or_create
    work_week
  rescue InvalidDates
    # year and/or number failed to parse as valid date
  end

  def initialize(year, number)
    @year = year.to_i
    @number = number.to_i
    @work_days = []
  end

  def find_or_create
    self.work_days = dates.map do |date|
      WorkDay.find_or_create_by!(date: date)
    end
  end

  def date_span
    monday = dates.first
    friday = dates.last
    (monday..friday).to_fs(:date_span)
  end

  def target_date
    dates.first
  end

  private

  def week_to_date_ids
    days = work_days.select { |day| day.date <= Time.zone.today }
    days.map(&:id)
  end

  def dates
    @dates ||= compute_dates
  end

  def compute_dates
    raise InvalidDates unless @year.positive? && @number.positive?

    (1..5).map { |day| Date.commercial(@year, @number, day) }
  rescue
    raise InvalidDates
  end
end
