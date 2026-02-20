class CreateBlogPosts < ActiveRecord::Migration[8.0]
  def change
    create_table :blog_posts do |t|
      t.integer :number, null: false
      t.string :summary, null: false
      t.string :title, null: false
      t.string :url, null: false
      t.date :published_on, null: false
      t.timestamp :announced_at

      t.timestamps

      t.index :url, unique: true
    end
  end
end
