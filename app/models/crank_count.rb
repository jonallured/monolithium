class CrankCount < ApplicationRecord
  belongs_to :crank_user

  validates :cranked_on, presence: true
  validates :ticks, presence: true

  def self.for_leaderboard
    where(cranked_on: Date.today).order(ticks: :desc).limit(10)
  end
end
