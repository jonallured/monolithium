class BackfillApacheLogDataJob < ApplicationJob
  def self.first_day
    Date.new(2021, 5, 26)
  end

  def perform(as_of = Date.yesterday)
    days = (BackfillApacheLogDataJob.first_day..as_of).to_a

    import_jobs = days.map do |day|
      file_timestamp = day.strftime("%Y%m%d")
      ImportApacheLogFileJob.new(file_timestamp)
    end

    ActiveJob.perform_all_later(import_jobs)
  end
end
