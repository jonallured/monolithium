module ApplicationHelper
  def last_week_path(work_week)
    target_date = work_week.target_date - 1.week
    target = TargetSlug.for(target_date)
    work_week_path(target)
  end

  def next_week_path(work_week)
    target_date = work_week.target_date + 1.week
    target = TargetSlug.for(target_date)
    work_week_path(target)
  end

  def this_week_path
    target = TargetSlug.for(Time.zone.today)
    work_week_path(target)
  end
end
