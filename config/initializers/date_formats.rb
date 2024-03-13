Date::DATE_FORMATS[:default] = "%m/%d/%Y"

Time::DATE_FORMATS[:default] = "%m/%d/%Y %I:%M:%S%P"

Range::RANGE_FORMATS[:date_span] = proc do |start, stop|
  same_year = start.year == stop.year
  same_month = start.month == stop.month

  rhs_format = same_month ? "%d, %Y" : "%b %d, %Y"
  rhs = stop.strftime(rhs_format)

  lhs_format = same_year ? "%b %d" : "%b %d, %Y"
  lhs = start.strftime(lhs_format)

  [lhs, rhs].join("-")
end
