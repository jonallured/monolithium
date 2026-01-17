class ApacheLogFile::Extractor < ActiveRecord::AssociatedObject
  class NotPendingError < StandardError; end
  class UnexpectedOverlapError < StandardError; end

  def self.find_missing
    keys = S3Api.list("domino/logs/")
    pattern = /domino\/logs\/access\.log-(\d{8})\.gz/

    dateexts = keys.map do |key|
      match_data = key.match(pattern)
      next if match_data.nil?
      match_data[1]
    end.compact.sort

    overlap = ApacheLogFile.where(dateext: dateexts).count
    raise UnexpectedOverlapError unless overlap.zero?

    dateexts
  end

  def run
    raise NotPendingError unless apache_log_file.pending?

    download_raw_lines
    archive_files

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

  def archive_files
    apache_log_file.s3_keys.values.each do |source_key|
      destination_key = source_key.gsub("logs", "archives")
      S3Api.move(source_key, destination_key)
    end
  end
end
