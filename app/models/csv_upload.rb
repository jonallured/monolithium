require "csv"

class CsvUpload < ApplicationRecord
  validates_presence_of :data, :original_filename, :parser_class_name

  def parsed_data
    CSV.parse(data)
  rescue CSV::MalformedCSVError
    nil
  end

  def table_attrs
    [
      ["Parser Class Name", parser_class_name],
      ["Original Filename", original_filename],
      ["Created At", created_at.to_fs],
      ["Updated At", updated_at.to_fs]
    ]
  end
end
