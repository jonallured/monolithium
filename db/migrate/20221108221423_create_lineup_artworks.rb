class CreateLineupArtworks < ActiveRecord::Migration[6.1]
  def change
    create_table :lineup_artworks do |t|
      t.belongs_to :artwork
      t.belongs_to :lineup
      t.integer :position

      t.timestamps
    end
  end
end
