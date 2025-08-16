class FinancialAccount < ApplicationRecord
  CATEGORIES = %w[
    checking
    savings
    health_savings
    good_debt
    bad_debt
    retirement
  ]

  has_many :financial_statements, dependent: :destroy
  has_many :financial_transactions, dependent: :destroy

  validates_presence_of :name
  validates_uniqueness_of :name
  validates_inclusion_of :category, in: CATEGORIES

  def self.permitted_params
    [
      :category,
      :name
    ]
  end

  def table_attrs
    [
      ["Name", name],
      ["Category", category],
      ["Created At", created_at.to_fs],
      ["Updated At", updated_at.to_fs]
    ]
  end
end
