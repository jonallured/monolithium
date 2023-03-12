class OneDayJob < ApplicationJob
  def perform
    RawHook.destroy_all
  end
end
