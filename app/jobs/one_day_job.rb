class OneDayJob < ApplicationJob
  def perform
    Hook.delete_all
    RawHook.delete_all
    DailyPacket::Producer.save_to(:s3)
  end
end
