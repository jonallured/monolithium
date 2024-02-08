class CreateFinancialTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :financial_transactions do |t|
      t.belongs_to :financial_account
      t.date :posted_on
      t.integer :amount_cents
      t.string :description
      t.timestamps
    end
  end
end
