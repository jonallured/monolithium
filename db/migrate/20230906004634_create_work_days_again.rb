class CreateWorkDaysAgain < ActiveRecord::Migration[7.0]
  def change
    create_table :work_days do |t|
      t.date :date, null: false

      t.integer :adjust_minutes
      t.integer :in_minutes
      t.integer :out_minutes
      t.integer :pto_minutes

      t.timestamps
    end
  end
end
