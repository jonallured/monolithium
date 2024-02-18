class Admin::FinancialAccountsController < ApplicationController
  expose(:financial_account)
  expose(:financial_accounts) do
    FinancialAccount.order(created_at: :desc).page(params[:page])
  end
end
