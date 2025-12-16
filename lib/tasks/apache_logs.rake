namespace :apache_logs do
  desc "Backfill Apache log data"
  task backfill: :environment do
    BackfillApacheLogDataJob.perform_later
  end

  desc "Import Apache log file by dateext"
  task :import, [:dateext] => :environment do |_task, args|
    dateext = args[:dateext]
    ImportApacheLogFileJob.perform_later(dateext)
  end
end
