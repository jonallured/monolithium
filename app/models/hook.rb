class Hook < ApplicationRecord
  CHANNEL_NAME = "hooks"

  belongs_to :raw_hook
  belongs_to :webhook_sender

  after_create_commit :created

  private

  def created
    broadcast_prepend_later_to CHANNEL_NAME, template: "cybertail/_hook"
  end
end
