class TrainingDay < ApplicationRecord
  has_many :training_activities, dependent: :destroy
  validates :date, presence: true
  validates :intensity, presence: true, inclusion: {in: %w[lift recovery rest]}
  validates :with_coach, inclusion: {in: [true, false]}
end
