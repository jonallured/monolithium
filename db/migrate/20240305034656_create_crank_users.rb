class CreateCrankUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :crank_users do |t|
      t.string :code, null: false
      t.timestamps
    end

    add_index :crank_users, :code, unique: true
  end
end
