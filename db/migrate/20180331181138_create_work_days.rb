class CreateWorkDays < ActiveRecord::Migration[5.1]
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
