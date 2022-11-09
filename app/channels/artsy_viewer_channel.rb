class ArtsyViewerChannel < ApplicationCable::Channel
  CHANNEL_ID = 'artsy_viewer'.freeze

  def subscribed
    transmit initial_payload
  end

  private

  def initial_payload
    Lineup.current.artworks
  end
end
