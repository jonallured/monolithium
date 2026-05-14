class Workout < ApplicationRecord
  has_many :training_activities, dependent: :destroy
  validates :title, presence: true

  def self.permitted_params
    [
      :title
    ]
  end

  def table_attrs
    [
      ["Title", title],
      ["Created At", created_at],
      ["Updated At", updated_at]
    ]
  end
end
