namespace :every do
  desc 'Task to run every ten minutes.'
  task ten_minutes: :environment do
    TenMinuteJob.perform_later
  end

  desc 'Task to run every one hour.'
  task one_hour: :environment do
    OneHourJob.perform_later
  end

  desc 'Task to run every one day.'
  task one_day: :environment do
    OneDayJob.perform_later
  end
end
