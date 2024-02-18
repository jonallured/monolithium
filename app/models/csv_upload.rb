require "csv"

class CsvUpload < ApplicationRecord
  validates_presence_of :data, :original_filename, :parser_class_name

  def parsed_data
    CSV.parse(data)
  rescue CSV::MalformedCSVError
    nil
  end
end
