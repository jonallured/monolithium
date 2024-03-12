class CrankCount < ApplicationRecord
  belongs_to :crank_user

  validates :cranked_on, presence: true
  validates :ticks, presence: true
end
