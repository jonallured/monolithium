class ApacheLogItem < ApplicationRecord
  belongs_to :apache_log_file
  validates :line_number, :raw_line, presence: true
end
