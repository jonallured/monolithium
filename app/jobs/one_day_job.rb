class OneDayJob < ApplicationJob
  def perform
    RawHook.destroy_all
    DailyPacket.produce_for(Date.today)
  end
end
