FactoryBot.define do
  factory :apache_log_item do
    apache_log_file
    line_number { 1 }
    raw_line { "GET /index.html HTTP/1.1" }
  end
end
