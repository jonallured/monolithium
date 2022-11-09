class CreateLineupJob < ApplicationJob
  def perform
    Lineup.create_next
  end
end
