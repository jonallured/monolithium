class ArtsyViewerChannel < ApplicationCable::Channel
  CHANNEL_ID = 'artsy_viewer'.freeze

  def subscribed
    transmit initial_payload
  end

  private

  def initial_payload
    Artwork.all.sample(10)
  end
end
