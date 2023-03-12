class Hook < ApplicationRecord
  belongs_to :raw_hook

  after_create_commit :created

  private

  def created
    broadcast_prepend_later_to "hooks"
  end
end
