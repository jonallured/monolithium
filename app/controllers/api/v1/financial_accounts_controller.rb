module Api
  module V1
    class FinancialAccountsController < Api::V1Controller
      include Indexable

      rescue_from ActiveRecord::RecordInvalid, with: :record_unprocessable

      index_model FinancialAccount

      expose(:financial_account)
      expose(:financial_accounts) { index_query.records }

      def create
        financial_account.save!
        render :show, status: :created
      end

      def update
        financial_account.update!(financial_account_params)
        render :show
      end

      private

      def financial_account_params
        params.require(:financial_account).permit(FinancialAccount.permitted_params)
      end

      def record_unprocessable(error)
        render json: {error: error.message}, status: :unprocessable_content
      end
    end
  end
end
