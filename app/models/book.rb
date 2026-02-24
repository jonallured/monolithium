class Book < ApplicationRecord
  FORMATS = %w[print audio kindle]

  validates :finished_on, presence: true
  validates :format, inclusion: {in: FORMATS}
  validates :isbn, presence: true

  has_object :enhancer

  def self.permitted_params
    [
      :finished_on,
      :format,
      :isbn,
      :pages,
      :title
    ]
  end

  def table_attrs
    [
      ["ISBN", isbn],
      ["Title", title],
      ["Pages", pages],
      ["Format", format],
      ["Finished On", finished_on],
      ["Created At", created_at],
      ["Updated At", updated_at]
    ]
  end
end
