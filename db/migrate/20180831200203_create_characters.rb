class CreateCharacters < ActiveRecord::Migration[5.2]
  def change
    create_table :characters do |t|
      t.belongs_to :player
      t.belongs_to :season
      t.string :name
      t.boolean :out
      t.timestamps
    end
  end
end
