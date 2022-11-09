class Lineup < ApplicationRecord
  has_many :lineup_artworks, dependent: :destroy
end
