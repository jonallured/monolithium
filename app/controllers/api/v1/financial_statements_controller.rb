module Api
  module V1
    class FinancialStatementsController < Api::V1Controller
      include Indexable

      index_model FinancialStatement

      expose(:financial_statements) { index_query.records }
    end
  end
end
