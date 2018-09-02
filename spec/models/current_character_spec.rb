require 'rails_helper'

describe CurrentCharacter do
  describe '#id' do
    it 'returns the id of the character' do
      character = Character.create
      current_character = CurrentCharacter.new(character)
      expect(current_character.id).to eq character.id
    end
  end

  describe '#player_name' do
    it "returns the name of the character's player" do
      player = Player.create name: 'Player One'
      character = Character.create player: player
      current_character = CurrentCharacter.new(character)
      expect(current_character.player_name).to eq 'Player One'
    end
  end

  describe '#current_picks' do
    it 'returns the current picks for the character' do
      player = Player.create name: 'Player One'
      season = Season.create name: '2018'
      character = Character.create player: player, season: season
      week = Week.create number: 1, season: season
      team = Team.create
      character.picks.create week: week, team: team
      current_character = CurrentCharacter.new(character)
      expect(current_character.current_picks.count).to eq 1

      current_pick = current_character.current_picks.first
      expect(current_pick.week_number).to eq week.number
      expect(current_pick.team_id).to eq team.id
    end
  end
end
