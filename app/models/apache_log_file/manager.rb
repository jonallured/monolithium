class ApacheLogFile::Manager
  def self.process_files
    manager = new
    manager.process_files
    manager
  end

  attr_reader :existing_apache_log_files, :missing_dateexts

  def process_files
    review_files
    import_missing
    delete_existing
  end

  private

  def review_files
    keys = S3Api.list("domino/logs/")
    pattern = /domino\/logs\/access\.log-(\d{8})\.gz/

    dateexts = keys.map do |key|
      match_data = key.match(pattern)
      next if match_data.nil?
      match_data[1]
    end.compact.sort

    @existing_apache_log_files = ApacheLogFile.where(dateext: dateexts)
    existing_dateexts = existing_apache_log_files.pluck(:dateext)
    @missing_dateexts = dateexts - existing_dateexts
  end

  def import_missing
    import_jobs = @missing_dateexts.map do |dateext|
      ImportApacheLogFileJob.new(dateext)
    end

    return unless import_jobs.any?

    ActiveJob.perform_all_later(import_jobs)
  end

  def delete_existing
    @existing_apache_log_files.each do |apache_log_file|
      apache_log_file.s3_keys.values.each do |key|
        S3Api.delete(key)
      end
    end
  end
end
