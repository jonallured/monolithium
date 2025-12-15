class CreateApacheLogFiles < ActiveRecord::Migration[8.0]
  def change
    create_table :apache_log_files do |t|
      t.string :dateext, null: false
      t.string :state, null: false

      t.text :raw_lines
      t.jsonb :parsed_entries

      t.timestamps
    end
  end
end
