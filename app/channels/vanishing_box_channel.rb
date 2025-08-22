class VanishingBoxChannel < ApplicationCable::Channel
  CHANNEL_ID = "vanishing_box".freeze

  def self.broadcast(payload)
    ActionCable.server.broadcast(
      CHANNEL_ID,
      payload
    )
  end

  def subscribed
    stream_from CHANNEL_ID
  end
end
