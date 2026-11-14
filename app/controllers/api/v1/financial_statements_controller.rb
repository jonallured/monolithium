module Api
  module V1
    class FinancialStatementsController < Api::V1Controller
      include Indexable

      rescue_from ActiveRecord::RecordInvalid, with: :record_unprocessable

      index_model FinancialStatement

      expose(:financial_account, id: -> { params.require(:financial_statement).require(:financial_account_id) })
      expose(:financial_statement, build: ->(attrs) { financial_account.financial_statements.new(attrs) })
      expose(:financial_statements) { index_query.records }

      def create
        financial_statement.save!
        render :show, status: :created
      end

      def update
        financial_statement.update!(financial_statement_params)
        render :show
      end

      private

      def financial_statement_params
        params.require(:financial_statement).permit(FinancialStatement.permitted_params)
      end

      def record_unprocessable(error)
        render json: {error: error.message}, status: :unprocessable_content
      end
    end
  end
end
