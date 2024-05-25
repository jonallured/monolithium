class CreateSneakers < ActiveRecord::Migration[7.1]
  def change
    create_table :sneakers do |t|
      t.string :name, null: false
      t.text :details, null: false
      t.integer :amount_cents, null: false
      t.date :ordered_on, null: false

      t.timestamps
    end
  end
end
