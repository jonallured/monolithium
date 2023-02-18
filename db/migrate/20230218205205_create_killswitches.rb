class CreateKillswitches < ActiveRecord::Migration[6.1]
  def change
    create_table :killswitches do |t|
      t.integer :bad_builds, array: true, default: []
      t.integer :minimum_build
      t.timestamps
    end
  end
end
