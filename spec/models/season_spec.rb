require 'rails_helper'

describe Season do
  describe '#player_emails' do
    context 'with no characters' do
      it 'returns an empty array' do
        season = FactoryBot.create :season
        expect(season.player_emails).to eq []
      end
    end

    context 'with a couple characters' do
      it 'returns the emails for the players of those characters' do
        season = FactoryBot.create :season
        player1 = FactoryBot.create :player, email: 'player_1@example.com'
        FactoryBot.create :character, season: season, player: player1
        player2 = FactoryBot.create :player, email: 'player_2@example.com'
        FactoryBot.create :character, season: season, player: player2
        expect(season.player_emails).to eq [
          player1.email,
          player2.email
        ]
      end
    end
  end
end
