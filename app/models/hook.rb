class Hook < ApplicationRecord
  belongs_to :raw_hook
  belongs_to :webhook_sender

  after_create_commit :created

  private

  def created
    broadcast_prepend_later_to "hooks", template: "cybertail/_hook"
  end
end
