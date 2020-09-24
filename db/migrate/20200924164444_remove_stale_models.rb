class RemoveStaleModels < ActiveRecord::Migration[6.0]
  def up
    drop_table :characters
    drop_table :games
    drop_table :picks
    drop_table :players
    drop_table :random_picks
    drop_table :seasons
    drop_table :teams
    drop_table :weeks
    drop_table :work_days
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
