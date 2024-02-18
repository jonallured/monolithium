class GiftIdea < ApplicationRecord
  scope :available, -> { where("claimed_at IS NULL AND received_at IS NULL") }
  scope :claimed, -> { where("claimed_at IS NOT NULL AND received_at IS NULL") }
  scope :received, -> { where("received_at IS NOT NULL") }
  scope :not_received, -> { where("received_at IS NULL") }

  def table_attrs
    [
      ["Title", title],
      ["Website URL", website_url],
      ["Note", note]
    ]
  end
end
