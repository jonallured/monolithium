class CreateArtworks < ActiveRecord::Migration[6.1]
  def change
    create_table :artworks do |t|
      t.jsonb :payload, null: false
      t.string :gravity_id, null: false

      t.timestamps
    end

    add_index :artworks, :gravity_id, unique: true
  end
end
