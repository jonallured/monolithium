class Admin::FinancialAccountsController < ApplicationController
  expose(:financial_account)
  expose(:financial_accounts) do
    FinancialAccount.order(created_at: :desc).page(params[:page])
  end

  def create
    if financial_account.save
      flash.notice = "Financial Account successfully created"
      redirect_to admin_financial_account_path(financial_account)
    else
      flash.alert = financial_account.errors.full_messages.join(",")
      redirect_to new_admin_financial_account_path
    end
  end

  def update
    if financial_account.update(financial_account_params)
      flash.notice = "Financial Account successfully updated"
      redirect_to admin_financial_account_path(financial_account)
    else
      flash.alert = financial_account.errors.full_messages.join(",")
      redirect_to edit_admin_financial_account_path(financial_account)
    end
  end

  def destroy
    financial_account.destroy
    redirect_to admin_financial_accounts_path
  end

  private

  def financial_account_params
    params.require(:financial_account).permit(:name)
  end
end
