class TrainingActivity < ApplicationRecord
  belongs_to :training_day
  belongs_to :workout

  def self.permitted_params
    [
      :training_day_id,
      :workout_id
    ]
  end

  def table_attrs
    [
      ["Training Day ID", training_day_id],
      ["Workout ID", workout_id],
      ["Created At", created_at],
      ["Updated At", updated_at]
    ]
  end
end
