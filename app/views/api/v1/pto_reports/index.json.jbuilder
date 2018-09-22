json.array! pto_reports do |pto_report|
  json.year pto_report.year
  json.ytd_minutes pto_report.ytd_minutes
  json.all_minutes pto_report.all_minutes
  json.pto_days pto_report.pto_days, :date, :minutes
end
