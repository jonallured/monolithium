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

  private

  def financial_account_params
    params.require(:financial_account).permit(:name)
  end
end
