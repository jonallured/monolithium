class Crud::FinancialStatementsController < ApplicationController
  expose(:financial_account)

  expose(:financial_statement)
  expose(:financial_statements) do
    financial_account.financial_statements.order(created_at: :desc).page(params[:page])
  end

  def show
    redirect_to crud_financial_account_financial_statement_path(financial_account, FinancialStatement.random) if params[:id] == "random"
  end
end
