class ApacheLogFile::Extractor < ActiveRecord::AssociatedObject
  class NotPendingError < StandardError; end

  def run
    raise NotPendingError unless apache_log_file.pending?

    binary = S3Api.read(apache_log_file.starting_s3_key)
    raw_lines = Zlib.gunzip(binary)
    apache_log_file.update(
      raw_lines: raw_lines,
      state: "extracted"
    )
  end
end
