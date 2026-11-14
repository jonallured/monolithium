class AddUniqueIndexToFinancialStatements < ActiveRecord::Migration[8.1]
  def change
    add_index :financial_statements, [:financial_account_id, :period_start_on], unique: true
  end
end
