class CreateFinancialStatements < ActiveRecord::Migration[7.1]
  def change
    create_table :financial_statements do |t|
      t.belongs_to :financial_account
      t.date :period_start_on
      t.integer :starting_amount_cents
      t.integer :ending_amount_cents
      t.timestamps
    end
  end
end
