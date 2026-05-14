class TrainingDay < ApplicationRecord
  INTENSITIES = %w[lift recovery rest]

  has_many :training_activities, dependent: :destroy

  validates :date, presence: true
  validates :intensity, presence: true, inclusion: {in: INTENSITIES}
  validates :with_coach, inclusion: {in: [true, false]}

  def self.permitted_params
    [
      :date,
      :completed_at,
      :intensity,
      :with_coach
    ]
  end

  def table_attrs
    [
      ["Date", date],
      ["Intensity", intensity],
      ["With Coach", with_coach],
      ["Completed At", completed_at],
      ["Created At", created_at],
      ["Updated At", updated_at]
    ]
  end
end
