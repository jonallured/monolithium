class CreateGiftIdeas < ActiveRecord::Migration[7.0]
  def change
    create_table :gift_ideas do |t|
      t.string :title
      t.string :website_url
      t.text :note

      t.datetime :claimed_at
      t.datetime :received_at
      t.datetime :archived_at

      t.timestamps
    end
  end
end
