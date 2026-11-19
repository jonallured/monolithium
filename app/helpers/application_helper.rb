module ApplicationHelper
  def attr_table_value(key, value)
    if value.nil?
      "NIL"
    elsif value.is_a?(Date)
      value.to_fs
    elsif value.is_a?(Time)
      in_tz(value)
    elsif value.is_a?(Integer) && !key.ends_with?("ID")
      value.to_fs(:delimited)
    else
      value
    end
  end

  def in_tz(time)
    time_tag time, time.to_fs, data: {intz: false}
  end
end
