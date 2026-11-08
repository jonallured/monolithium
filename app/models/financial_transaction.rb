class FinancialTransaction < ApplicationRecord
  belongs_to :financial_account

  validates_presence_of :posted_on, :amount_cents, :description

  scope :for_year, ->(year) { where("extract(year from posted_on) = ?", year) }

  def self.default_index_sort
    "-posted_on"
  end

  def self.index_filters
    {financial_account_id: :id, posted_on: :date}
  end

  def self.index_sorts
    %w[amount_cents posted_on]
  end
end
