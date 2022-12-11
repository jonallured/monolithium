class AddBooks < ActiveRecord::Migration[6.1]
  def change
    create_table :books do |t|
      t.string :isbn
      t.date :finished_on
      t.string :title
      t.integer :pages

      t.timestamps
    end
  end
end
