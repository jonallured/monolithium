require 'rails_helper'

describe Lineup do
  describe '#as_of' do
    it 'returns the right artworks' do
      FactoryBot.create_list(:artwork, 24)
      lineup = FactoryBot.create(:lineup)

      first_hour = Time.zone.now.beginning_of_day
      second_hour = first_hour + 1.hour

      artwork_one = lineup.lineup_artworks.find_by(position: 1).artwork
      artwork_two = lineup.lineup_artworks.find_by(position: 2).artwork
      expect(lineup.as_of(first_hour)).to eq([artwork_one])
      expect(lineup.as_of(second_hour)).to eq([artwork_two, artwork_one])
    end
  end
end
