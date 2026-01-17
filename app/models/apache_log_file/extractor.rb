class ApacheLogFile::Extractor < ActiveRecord::AssociatedObject
  class NotPendingError < StandardError; end

  def run
    raise NotPendingError unless apache_log_file.pending?

    download_raw_lines

    apache_log_file.update(
      raw_lines: @raw_lines,
      state: "extracted"
    )
  end

  private

  def download_raw_lines
    access_log_key = apache_log_file.s3_keys[:access_log]
    binary = S3Api.read(access_log_key)
    @raw_lines = Zlib.gunzip(binary)
  end
end
