class FinancialTransaction < ApplicationRecord
  belongs_to :financial_account

  validates_presence_of :posted_on, :amount_cents, :description
end
