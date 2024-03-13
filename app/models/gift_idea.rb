class GiftIdea < ApplicationRecord
  validates_presence_of :title, :website_url

  scope :available, -> { where("claimed_at IS NULL AND received_at IS NULL") }
  scope :claimed, -> { where("claimed_at IS NOT NULL AND received_at IS NULL") }
  scope :received, -> { where("received_at IS NOT NULL") }
  scope :not_received, -> { where("received_at IS NULL") }

  def table_attrs
    [
      ["Title", title],
      ["Website URL", website_url],
      ["Note", note],
      ["Created At", created_at.to_fs],
      ["Updated At", updated_at.to_fs]
    ]
  end
end
