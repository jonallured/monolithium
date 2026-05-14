class CreateTrainingActivities < ActiveRecord::Migration[8.0]
  def change
    create_table :training_activities do |t|
      t.belongs_to :training_day
      t.belongs_to :workout
      t.timestamps
    end
  end
end
