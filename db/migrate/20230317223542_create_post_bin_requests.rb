class CreatePostBinRequests < ActiveRecord::Migration[7.0]
  def change
    create_table :post_bin_requests do |t|
      t.jsonb :headers
      t.jsonb :params
      t.text :body

      t.timestamps
    end
  end
end
