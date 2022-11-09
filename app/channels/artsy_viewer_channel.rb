class ArtsyViewerChannel < ApplicationCable::Channel
  CHANNEL_ID = 'artsy_viewer'.freeze

  def self.broadcast(payload)
    ActionCable.server.broadcast(
      CHANNEL_ID,
      payload
    )
  end

  def subscribed
    transmit initial_payload
    stream_from CHANNEL_ID
  end

  private

  def initial_payload
    Lineup.current.as_of(Time.zone.now)
  end
end
