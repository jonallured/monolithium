class ParseCsvUploadJob < ApplicationJob
  def perform(csv_upload_id)
    csv_upload = CsvUpload.find_by(id: csv_upload_id)
    return unless csv_upload

    parser = csv_upload.parser_class_name.constantize
    parser.parse(csv_upload)
  end
end
