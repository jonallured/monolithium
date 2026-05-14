class Workout < ApplicationRecord
  has_many :training_activities, dependent: :destroy
  validates :title, presence: true
end
