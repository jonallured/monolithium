class AddActiveToWorkouts < ActiveRecord::Migration[8.1]
  def change
    add_column :workouts, :active, :boolean, null: false, default: false
  end
end
