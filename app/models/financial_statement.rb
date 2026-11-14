class FinancialStatement < ApplicationRecord
  belongs_to :financial_account

  validates_presence_of :period_start_on, :starting_amount_cents, :ending_amount_cents
  validates_uniqueness_of :period_start_on, scope: :financial_account
  validate :period_start_on_is_first_of_month

  scope :for_year, ->(year) { where("extract(year from period_start_on) = ?", year) }

  def self.default_index_sort
    "-period_start_on"
  end

  def self.index_filters
    {financial_account_id: :id, period_start_on: :date}
  end

  def self.index_sorts
    %w[period_start_on]
  end

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
      ["Period Start On", period_start_on],
      ["Starting Amount Cents", starting_amount_cents],
      ["Ending Amount Cents", ending_amount_cents],
      ["Created At", created_at],
      ["Updated At", updated_at]
    ]
  end

  private

  def period_start_on_is_first_of_month
    return if period_start_on.nil? || period_start_on.day == 1

    errors.add(:period_start_on, "must be the first of a month")
  end
end
