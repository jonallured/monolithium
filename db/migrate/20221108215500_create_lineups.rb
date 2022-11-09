class CreateLineups < ActiveRecord::Migration[6.1]
  def change
    create_table :lineups do |t|
      t.date :current_on, null: false

      t.timestamps
    end

    add_index :lineups, :current_on, unique: true
  end
end
