class OneDayJob < ApplicationJob
  def perform
    Hook::Cleaner.drain
    DailyPacket::Producer.save_to(:s3)
  end
end
