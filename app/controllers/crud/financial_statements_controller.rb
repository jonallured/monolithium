class Crud::FinancialStatementsController < ApplicationController
  expose(:financial_account)

  expose(:financial_statements) do
    financial_account.financial_statements.order(created_at: :desc).page(params[:page])
  end
end
