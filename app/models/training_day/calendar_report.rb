class TrainingDay::CalendarReport
  def self.default_params
    date = Date.today
    params_for(date)
  end

  def self.params_for(start)
    month, year = start.strftime("%m %Y").split
    {month: month, year: year}
  end

  attr_reader :period_start

  def initialize(year, month)
    @period_start = Date.new(
      year.to_i,
      month.to_i
    )
  end

  def title
    @period_start.strftime("%b %Y")
  end

  def prev_params
    prev_start = @period_start - 1.month
    self.class.params_for(prev_start)
  end

  def next_params
    next_start = @period_start + 1.month
    self.class.params_for(next_start)
  end

  def training_day_groups
    all_month = @period_start.all_month
    month_days = TrainingDay.where(date: all_month).order(date: :asc)
    return [] unless month_days.any?

    before_filler = TrainingDay::FillerDay.fill_before(all_month.first)
    after_filler = TrainingDay::FillerDay.fill_after(all_month.last)
    days = before_filler + month_days + after_filler
    days.in_groups_of(7)
  end
end
