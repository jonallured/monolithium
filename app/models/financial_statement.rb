class FinancialStatement < ApplicationRecord
  belongs_to :financial_account

  validates_presence_of :period_start_on, :starting_amount_cents, :ending_amount_cents
  validates_uniqueness_of :period_start_on, scope: :financial_account

  scope :for_year, ->(year) { where("extract(year from period_start_on) = ?", year) }

  def net_amount_cents
    ending_amount_cents - starting_amount_cents
  end
end
