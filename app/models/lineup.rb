class Lineup < ApplicationRecord
  has_many :lineup_artworks, dependent: :destroy
  has_many :artworks, through: :lineup_artworks

  after_create :choose_artworks

  def self.create_next
    create(current_on: current.current_on + 1.day)
  end

  def self.current
    find_by(current_on: Time.zone.today)
  end

  def as_of(time)
    lineup_artworks
      .where('position <= ?', time.hour + 1)
      .order(position: :desc)
      .map(&:artwork)
  end

  private

  def choose_artworks
    artwork_ids = Artwork.pluck(:id).sample(24)
    artwork_ids.each_with_index do |artwork_id, index|
      lineup_artworks.create(artwork_id: artwork_id, position: index + 1)
    end
  end
end
