class FinancialAccount < ApplicationRecord
  has_many :financial_statements, dependent: :destroy
  has_many :financial_transactions, dependent: :destroy

  validates_presence_of :name
  validates_uniqueness_of :name

  def self.usb_checking
    find_by(name: "US Bank Checking")
  end

  def self.wf_checking
    find_by(name: "Wells Fargo Checking")
  end

  def self.wf_savings
    find_by(name: "Wells Fargo Savings")
  end

  def table_attrs
    [
      ["Name", name],
      ["Created At", created_at.to_fs],
      ["Updated At", updated_at.to_fs]
    ]
  end
end
