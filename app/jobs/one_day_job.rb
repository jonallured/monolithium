class OneDayJob < ApplicationJob
  def perform
    Hook.delete_all
    RawHook.delete_all
    DailyPacket.produce_for(Date.today)
  end
end
