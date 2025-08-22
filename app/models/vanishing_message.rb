class VanishingMessage
  def self.fire_and_forget(body)
    vanishing_message = new(body)
    vanishing_message.broadcast
    nil
  end

  def initialize(body)
    @body = body
    @created_at = Time.now
  end

  def broadcast
    VanishingBoxChannel.broadcast(as_payload)
  end

  private

  def as_payload
    {body: @body, created_at: @created_at.to_fs}
  end
end
