class CreateDailyPackets < ActiveRecord::Migration[7.2]
  def change
    create_table :daily_packets do |t|
      t.belongs_to :warm_fuzzy
      t.date :built_on, null: false
      t.float :reading_list_pace, null: false
      t.timestamps
    end
  end
end
