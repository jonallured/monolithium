class Workout < ApplicationRecord
  has_many :training_activities, dependent: :destroy
  validates :title, presence: true
  validates :active, inclusion: {in: [true, false]}

  scope :active, -> { where(active: true) }

  def self.permitted_params
    [
      :title,
      :active
    ]
  end

  def table_attrs
    [
      ["Title", title],
      ["Active", active],
      ["Created At", created_at],
      ["Updated At", updated_at]
    ]
  end
end
