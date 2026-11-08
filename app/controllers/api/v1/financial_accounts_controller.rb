module Api
  module V1
    class FinancialAccountsController < Api::V1Controller
      include Indexable

      index_model FinancialAccount

      expose(:financial_account)
      expose(:financial_accounts) { index_query.records }
    end
  end
end
