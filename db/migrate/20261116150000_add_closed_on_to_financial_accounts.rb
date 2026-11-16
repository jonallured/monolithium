class AddClosedOnToFinancialAccounts < ActiveRecord::Migration[8.1]
  def change
    add_column :financial_accounts, :closed_on, :date
  end
end
