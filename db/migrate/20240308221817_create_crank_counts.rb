class CreateCrankCounts < ActiveRecord::Migration[7.1]
  def change
    create_table :crank_counts do |t|
      t.belongs_to :crank_user
      t.integer :ticks, null: false
      t.date :cranked_on, null: false
      t.timestamps
    end
  end
end
