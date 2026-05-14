class CreateTrainingDays < ActiveRecord::Migration[8.0]
  def change
    create_table :training_days do |t|
      t.date :date, null: false, index: {unique: true}
      t.string :intensity, null: false
      t.datetime :completed_at
      t.boolean :with_coach, null: false
      t.timestamps
    end
  end
end
