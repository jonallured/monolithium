class CreateProjects < ActiveRecord::Migration[5.1]
  def change
    create_table :projects do |t|
      t.string :name
      t.timestamp :touched_at
      t.timestamps
    end
  end
end
