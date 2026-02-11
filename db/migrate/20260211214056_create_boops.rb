class CreateBoops < ActiveRecord::Migration[8.0]
  def change
    create_table :boops do |t|
      t.string :display_type, null: false
      t.integer :number, null: false
      t.timestamp :dismissed_at
      t.timestamps
    end
  end
end
