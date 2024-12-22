class Book < ApplicationRecord
  FORMATS = %w[print audio kindle]

  validates :finished_on, presence: true
  validates :format, inclusion: {in: FORMATS}
  validates :isbn, presence: true

  has_object :enhancer

  def table_attrs
    [
      ["ISBN", isbn],
      ["Title", title],
      ["Pages", pages],
      ["Format", format],
      ["Finished On", finished_on.to_fs],
      ["Created At", created_at.to_fs],
      ["Updated At", updated_at.to_fs]
    ]
  end
end
