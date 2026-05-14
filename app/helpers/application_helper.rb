module ApplicationHelper
  def attr_table_value(value)
    if value.nil?
      "NIL"
    elsif value.is_a?(Date)
      value.to_fs
    elsif value.is_a?(Time)
      in_tz(value)
    elsif value.is_a?(Integer)
      value.to_fs(:delimited)
    else
      value
    end
  end

  def in_tz(time)
    time_tag time, time.to_fs, data: {intz: false}
  end

  def book_format_options
    placeholder_option = [["please select", ""]]

    format_options = Book::FORMATS.map do |format|
      [format, format]
    end

    placeholder_option + format_options
  end

  def training_day_intensity_options
    placeholder_option = [["please select", ""]]

    intensity_options = TrainingDay::INTENSITIES.map do |intensity|
      [intensity, intensity]
    end

    placeholder_option + intensity_options
  end

  def training_day_with_coach_options
    placeholder_option = [["please select", ""]]

    with_coach_options = [true, false].map do |with_coach|
      [with_coach, with_coach]
    end

    placeholder_option + with_coach_options
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
