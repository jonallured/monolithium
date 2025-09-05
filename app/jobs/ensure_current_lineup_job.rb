class EnsureCurrentLineupJob < ApplicationJob
  def perform
    Lineup::Builder.ensure_current
  end
end
