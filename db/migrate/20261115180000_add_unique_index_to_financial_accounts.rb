class AddUniqueIndexToFinancialAccounts < ActiveRecord::Migration[8.1]
  def change
    add_index :financial_accounts, :name, unique: true
  end
end
