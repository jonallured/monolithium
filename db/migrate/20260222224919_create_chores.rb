class CreateChores < ActiveRecord::Migration[8.0]
  def change
    create_table :chores do |t|
      t.string :title, null: false
      t.integer :assignee, null: false
      t.integer :due_days, array: true, default: []

      t.timestamps
    end
  end
end
