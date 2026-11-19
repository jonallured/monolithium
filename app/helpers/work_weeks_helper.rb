module WorkWeeksHelper
  def last_week_path(work_week)
    week_path_for(work_week.target_date - 1.week)
  end

  def next_week_path(work_week)
    week_path_for(work_week.target_date + 1.week)
  end

  def this_week_path
    week_path_for(Time.zone.today)
  end

  private

  def week_path_for(date)
    work_week_path(TargetSlug.for(date))
  end
end
