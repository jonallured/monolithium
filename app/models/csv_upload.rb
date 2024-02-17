class CsvUpload < ApplicationRecord
  validates_presence_of :data, :original_filename, :parser_class_name
end
