class GetMissingApacheLogDataJob < ApplicationJob
  def perform
    missing_dateexts = ApacheLogFile::Extractor.find_missing

    import_jobs = missing_dateexts.map do |dateext|
      ImportApacheLogFileJob.new(dateext)
    end

    ActiveJob.perform_all_later(import_jobs)
  end
end
