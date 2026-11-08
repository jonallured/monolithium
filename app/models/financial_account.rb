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

  def self.default_index_sort
    "category,name"
  end

  def self.index_filters
    {category: CATEGORIES}
  end

  def self.index_sorts
    %w[category name]
  end

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
      ["Created At", created_at],
      ["Updated At", updated_at]
    ]
  end
end
