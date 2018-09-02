class CreateGames < ActiveRecord::Migration[5.2]
  def change
    create_table :games do |t|
      t.belongs_to :away_team
      t.belongs_to :home_team
      t.belongs_to :week
      t.integer :away_score
      t.integer :home_score
      t.datetime :played_at
      t.timestamps
    end
  end
end
