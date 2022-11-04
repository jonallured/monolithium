class OneDayJob < ApplicationJob
  def perform
    Hook.destroy_all
  end
end
