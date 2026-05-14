class TrainingDay::WeekReport
  def self.default_params
    date = Date.today
    params_for(date)
  end

  def self.params_for(date)
    date = date.sunday? ? date + 1.day : date

    {
      number: date.strftime("%V"),
      year: date.cwyear
    }
  end

  def initialize(year, number)
    @period_start = Date.commercial(
      year.to_i,
      number.to_i
    )
  end

  def title
    last_day.strftime("%Y-%V")
  end

  def training_days
    TrainingDay.where(date: all_week).order(date: :asc)
  end

  def all_week
    @period_start.all_week(:sunday)
  end

  def month_dates
    dates = [first_day]
    dates << last_day if first_day.month != last_day.month
    dates
  end

  def first_day
    all_week.first
  end

  def last_day
    all_week.last
  end

  def prev_params
    date = last_day - 1.week
    self.class.params_for(date)
  end

  def next_params
    date = last_day + 1.week
    self.class.params_for(date)
  end
end
