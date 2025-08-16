class WarmFuzzy < ApplicationRecord
  has_one_attached :screenshot

  validates :author, presence: true
  validates :received_at, presence: true
  validates :title, presence: true

  def self.permitted_params
    [
      :author,
      :body,
      :received_at,
      :screenshot,
      :title
    ]
  end

  def table_attrs
    [
      ["Title", title],
      ["Author", author],
      ["Body", body],
      ["Received At", received_at.to_fs],
      ["Created At", created_at.to_fs],
      ["Updated At", updated_at.to_fs]
    ]
  end
end
