class CreateWeeks < ActiveRecord::Migration[5.2]
  def change
    create_table :weeks do |t|
      t.belongs_to :season
      t.integer :number
      t.timestamps
    end
  end
end
