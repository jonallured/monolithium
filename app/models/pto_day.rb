class PtoDay
  def initialize(work_day)
    @work_day = work_day
  end

  def date
    @work_day.date
  end

  def minutes
    @work_day.pto_minutes
  end
end
