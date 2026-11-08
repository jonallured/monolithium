module Api
  module V1
    class FinancialTransactionsController < Api::V1Controller
      include Indexable

      index_model FinancialTransaction

      expose(:financial_transactions) { index_query.records }
    end
  end
end
