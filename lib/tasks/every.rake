namespace :every do
  desc "Task to run every one hour."
  task one_hour: :environment do
    PushCurrentLineupJob.perform_later
  end

  desc "Task to run every one day."
  task one_day: :environment do
    job_klasses = [
      OneDayJob,
      LoadArtworksJob,
      CreateLineupJob
    ]

    job_klasses.each(&:perform_later)
  end
end
