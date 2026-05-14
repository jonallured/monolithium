class CreateWorkouts < ActiveRecord::Migration[8.0]
  def change
    create_table :workouts do |t|
      t.string :title, null: false
      t.timestamps
    end
  end
end
