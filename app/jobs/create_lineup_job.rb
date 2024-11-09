class CreateLineupJob < ApplicationJob
  def perform
    Lineup.create_next while Lineup.current.nil?
    Lineup.create_next
  end
end
