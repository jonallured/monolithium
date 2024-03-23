class Crud::FinancialStatementsController < ApplicationController
  expose(:financial_account)

  expose(:financial_statement, parent: :financial_account)
  expose(:financial_statements) do
    financial_account.financial_statements.order(created_at: :desc).page(params[:page])
  end

  def show
    redirect_to crud_financial_account_financial_statement_path(financial_account, FinancialStatement.random) if params[:id] == "random"
  end

  def create
    if financial_statement.save
      flash.notice = "Financial Statement created"
      redirect_to crud_financial_account_financial_statement_path(financial_account, financial_statement)
    else
      flash.alert = financial_statement.errors.full_messages.to_sentence
      redirect_to new_crud_financial_account_financial_statement_path(financial_account)
    end
  end

  def update
    if financial_statement.update(financial_statement_params)
      flash.notice = "Financial Statement updated"
      redirect_to crud_financial_account_financial_statement_path(financial_account, financial_statement)
    else
      flash.alert = financial_statement.errors.full_messages.to_sentence
      redirect_to edit_crud_financial_account_financial_statement_path(financial_account)
    end
  end

  private

  def financial_statement_params
    params.require(:financial_statement).permit(:ending_amount_cents, :period_start_on, :starting_amount_cents)
  end
end
