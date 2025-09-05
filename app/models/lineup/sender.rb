class Lineup::Sender
  def self.push_current
    artworks = Lineup.current.as_of(Time.zone.now)
    ArtsyViewerChannel.broadcast(artworks)
  end
end
