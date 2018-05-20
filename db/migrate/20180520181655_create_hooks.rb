class CreateHooks < ActiveRecord::Migration[5.2]
  def change
    create_table :hooks do |t|
      t.json :payload
      t.timestamps
    end
  end
end
