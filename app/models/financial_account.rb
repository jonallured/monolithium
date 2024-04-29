class FinancialAccount < ApplicationRecord
  has_many :financial_statements, dependent: :destroy
  has_many :financial_transactions, dependent: :destroy

  validates_presence_of :name
  validates_uniqueness_of :name
  validates_inclusion_of :category, in: %w[checking savings]

  scope :checking, -> { where(category: "checking") }
  scope :savings, -> { where(category: "savings") }

  def table_attrs
    [
      ["Name", name],
      ["Category", category],
      ["Created At", created_at.to_fs],
      ["Updated At", updated_at.to_fs]
    ]
  end
end
