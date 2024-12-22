class AddFormatToBooks < ActiveRecord::Migration[8.0]
  def up
    add_column :books, :format, :string
    Book.update_all(format: "print")
    change_column_null :books, :format, false
  end

  def down
    remove_column :books, :format
  end
end
