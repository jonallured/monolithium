class CreateRandomPicks < ActiveRecord::Migration[5.2]
  def change
    create_table :random_picks do |t|
      t.belongs_to :team
      t.belongs_to :week
      t.timestamps
    end
  end
end
