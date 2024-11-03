class AddFeedbinStatsToDailyPackets < ActiveRecord::Migration[7.2]
  def change
    add_column :daily_packets, :feedbin_unread_count, :integer, null: false, default: 0
    add_column :daily_packets, :feedbin_oldest_ago, :integer, null: false, default: 0
  end
end
