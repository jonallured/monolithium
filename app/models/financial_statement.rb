class FinancialStatement < ApplicationRecord
  belongs_to :financial_account

  validates_presence_of :period_start_on, :starting_amount_cents, :ending_amount_cents
  validates_uniqueness_of :period_start_on, scope: :financial_account

  scope :for_year, ->(year) { where("extract(year from period_start_on) = ?", year) }

  def self.permitted_params
    [
      :ending_amount_cents,
      :period_start_on,
      :starting_amount_cents
    ]
  end

  def net_amount_cents
    ending_amount_cents - starting_amount_cents
  end

  def table_attrs
    [
      ["Period Start On", period_start_on.to_fs],
      ["Starting Amount Cents", starting_amount_cents],
      ["Ending Amount Cents", ending_amount_cents],
      ["Created At", created_at.to_fs],
      ["Updated At", updated_at.to_fs]
    ]
  end
end
