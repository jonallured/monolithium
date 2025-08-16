class Crud::FinancialStatementsController < ApplicationController
  expose(:financial_account)

  expose(:financial_statement, parent: :financial_account)
  expose(:financial_statements) do
    financial_account.financial_statements.order(created_at: :desc).page(params[:page])
  end

  def show
    if random_id?
      if random_financial_statement
        redirect_to crud_financial_account_financial_statement_path(financial_account, random_financial_statement)
      else
        flash.alert = "No records found!"
        redirect_to crud_financial_account_financial_statements_path(financial_account)
      end
    end
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

  def destroy
    financial_statement.destroy
    flash.notice = "Financial Statement deleted"
    redirect_to crud_financial_account_financial_statements_path(financial_account)
  end

  private

  def financial_statement_params
    params.require(:financial_statement).permit(FinancialStatement.permitted_params)
  end

  def random_financial_statement
    @random_financial_statement ||= FinancialStatement.random
  end
end
