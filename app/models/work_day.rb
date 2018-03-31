class WorkDay < ApplicationRecord
  validates :date, presence: true, uniqueness: true
  delegate :year, to: :date
end
