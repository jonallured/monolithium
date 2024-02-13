class FinancialTransaction < ApplicationRecord
  belongs_to :financial_account

  validates_presence_of :posted_on, :amount_cents, :description

  scope :for_year, ->(year) { where("extract(year from posted_on) = ?", year) }
end
