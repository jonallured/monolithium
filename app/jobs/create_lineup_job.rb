class CreateLineupJob < ApplicationJob
  def perform
    while Lineup.current.nil?
      Lineup.create_next
    end
  end
end
