namespace :apache_logs do
  desc "Import Apache log file by dateext"
  task :import, [:dateext] => :environment do |_task, args|
    dateext = args[:dateext]
    ImportApacheLogFileJob.perform_later(dateext)
  end
end
