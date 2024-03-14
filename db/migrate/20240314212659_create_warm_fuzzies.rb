class CreateWarmFuzzies < ActiveRecord::Migration[7.1]
  def change
    create_table :warm_fuzzies do |t|
      t.string :author, null: false
      t.string :title, null: false
      t.text :body
      t.timestamp :received_at, null: false

      t.timestamps
    end
  end
end
