class Character < ApplicationRecord
  belongs_to :player
  belongs_to :season

  has_many :picks, dependent: :destroy

  def score
    picks.map(&:score).sum
  end
end
