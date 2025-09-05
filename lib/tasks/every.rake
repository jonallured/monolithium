namespace :every do
  desc "Task to run every one hour."
  task one_hour: :environment do
    PushCurrentLineupJob.perform_later
  end

  desc "Task to run every one day."
  task one_day: :environment do
    DrainHooksJob.perform_later
    ProduceDailyPacketJob.perform_later
    CrawlArtworksJob.perform_later
    EnsureCurrentLineupJob.perform_later
  end
end
