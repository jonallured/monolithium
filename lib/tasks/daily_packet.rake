namespace :daily_packet do
  desc "Produce today's packet and save locally."
  task save_locally: :environment do
    DailyPacket.save_locally
  end

  desc "Produce today's packet and save to S3"
  task save_to_s3: :environment do
    DailyPacket.save_to_s3
  end
end
