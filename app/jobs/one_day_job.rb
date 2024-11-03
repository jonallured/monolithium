class OneDayJob < ApplicationJob
  def perform
    Hook.delete_all
    RawHook.delete_all
    DailyPacketService.save_to_s3
  end
end
