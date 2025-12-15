class CreateApacheLogItems < ActiveRecord::Migration[8.0]
  def change
    create_table :apache_log_items do |t|
      t.belongs_to :apache_log_file, null: false
      t.integer :line_number, null: false
      t.string :raw_line, null: false

      t.string :website
      t.string :port
      t.string :remote_ip_address
      t.string :remote_logname
      t.string :remote_user
      t.datetime :requested_at
      t.string :request_method
      t.string :request_path
      t.string :request_params
      t.string :request_protocol
      t.string :response_status
      t.integer :response_size
      t.string :request_referrer
      t.string :request_user_agent
      t.string :browser_name
      t.string :referrer_host

      t.index :requested_at

      t.timestamps
    end
  end
end
