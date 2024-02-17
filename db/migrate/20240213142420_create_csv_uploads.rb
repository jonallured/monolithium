class CreateCsvUploads < ActiveRecord::Migration[7.1]
  def change
    create_table :csv_uploads do |t|
      t.text :data
      t.string :parser_class_name
      t.string :original_filename
      t.timestamps
    end
  end
end
