class TrainingActivity < ApplicationRecord
  belongs_to :training_day
  belongs_to :workout
end
