class CreateRawHooks < ActiveRecord::Migration[7.0]
  def change
    create_table :raw_hooks do |t|
      t.jsonb :headers
      t.jsonb :params
      t.text :body

      t.timestamps
    end
  end
end
