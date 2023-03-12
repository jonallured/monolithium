class ConnectHookToRawHook < ActiveRecord::Migration[7.0]
  def change
    change_table :hooks do |t|
      t.remove :payload
      t.belongs_to :raw_hook
      t.string :message
    end
  end
end
