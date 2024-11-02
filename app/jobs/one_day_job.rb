class OneDayJob < ApplicationJob
  def perform
    Hook.delete_all
    RawHook.delete_all
    DailyPacket.save_to_s3
  end
end
