class Sneaker < ApplicationRecord
  validates :amount_cents, presence: true
  validates :details, presence: true
  validates :name, presence: true
  validates :ordered_on, presence: true

  has_one_attached :image

  def table_attrs
    [
      ["Name", name],
      ["Details", details],
      ["Amount Cents", amount_cents],
      ["Ordered On", ordered_on.to_fs],
      ["Created At", created_at.to_fs],
      ["Updated At", updated_at.to_fs]
    ]
  end
end
