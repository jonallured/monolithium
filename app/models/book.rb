class Book < ApplicationRecord
  validates :isbn, presence: true
  validates :finished_on, presence: true

  has_object :enhancer

  def table_attrs
    [
      ["ISBN", isbn],
      ["Title", title],
      ["Pages", pages],
      ["Finished On", finished_on.to_fs],
      ["Created At", created_at.to_fs],
      ["Updated At", updated_at.to_fs]
    ]
  end
end
