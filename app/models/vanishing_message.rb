class VanishingMessage
  def self.fire_and_forget(secret)
    vanishing_message = new(secret)
    vanishing_message.broadcast
    nil
  end

  def initialize(secret)
    @secret = secret
    @created_at = Time.now
  end

  def broadcast
    VanishingBoxChannel.broadcast(as_payload)
  end

  private

  def as_payload
    {secret: @secret, created_at: @created_at.to_fs}
  end
end
