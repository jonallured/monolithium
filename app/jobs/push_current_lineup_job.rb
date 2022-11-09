class PushCurrentLineupJob < ApplicationJob
  def perform
    artworks = Lineup.current.as_of(Time.zone.now)
    ArtsyViewerChannel.broadcast(artworks)
  end
end
