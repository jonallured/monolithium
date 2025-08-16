class Crud::FinancialAccountsController < ApplicationController
  expose(:financial_account)
  expose(:financial_accounts) do
    FinancialAccount.order(created_at: :desc).page(params[:page])
  end

  def show
    redirect_to crud_financial_account_path(FinancialAccount.random) if random_id?
  end

  def create
    if financial_account.save
      flash.notice = "Financial Account created"
      redirect_to crud_financial_account_path(financial_account)
    else
      flash.alert = financial_account.errors.full_messages.to_sentence
      redirect_to new_crud_financial_account_path
    end
  end

  def update
    if financial_account.update(financial_account_params)
      flash.notice = "Financial Account updated"
      redirect_to crud_financial_account_path(financial_account)
    else
      flash.alert = financial_account.errors.full_messages.to_sentence
      redirect_to edit_crud_financial_account_path(financial_account)
    end
  end

  def destroy
    financial_account.destroy
    flash.notice = "Financial Account deleted"
    redirect_to crud_financial_accounts_path
  end

  private

  def financial_account_params
    params.require(:financial_account).permit(FinancialAccount.permitted_params)
  end
end
