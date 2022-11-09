class Lineup < ApplicationRecord
  has_many :lineup_artworks, dependent: :destroy
  has_many :artworks, through: :lineup_artworks

  def self.current
    find_by(current_on: Time.zone.today)
  end
end
