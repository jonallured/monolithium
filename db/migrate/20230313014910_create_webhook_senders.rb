class CreateWebhookSenders < ActiveRecord::Migration[7.0]
  def change
    create_table :webhook_senders do |t|
      t.string :name
      t.string :parser
      t.timestamps
    end

    change_table :hooks do |t|
      t.belongs_to :webhook_sender
    end
  end
end
