class AddEditionNumberToDailyPackets < ActiveRecord::Migration[7.2]
  def change
    add_column :daily_packets, :edition_number, :integer, null: false, default: 0
  end
end
