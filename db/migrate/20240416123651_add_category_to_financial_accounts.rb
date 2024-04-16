class AddCategoryToFinancialAccounts < ActiveRecord::Migration[7.1]
  def up
    add_column :financial_accounts, :category, :string
    FinancialAccount.update_all(category: "checking")
    change_column_null :financial_accounts, :category, false
  end

  def down
    remove_column :financial_accounts, :category
  end
end
