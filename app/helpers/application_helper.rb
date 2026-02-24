module ApplicationHelper
  def attr_table_value(value)
    if value.nil?
      "NIL"
    elsif value.is_a?(Date)
      value.to_fs
    elsif value.is_a?(Time)
      value.to_fs
    elsif value.is_a?(Integer)
      value.to_fs(:delimited)
    else
      value
    end
  end

  def book_format_options
    placeholder_option = [["please select", ""]]

    format_options = Book::FORMATS.map do |format|
      [format, format]
    end

    placeholder_option + format_options
  end

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
