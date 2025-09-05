class PushCurrentLineupJob < ApplicationJob
  def perform
    Lineup::Sender.push_current
  end
end
